import os
import warnings
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from supabase.client import create_client, Client
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.llms import LlamaCpp
from langchain_core.prompts import PromptTemplate
from contextlib import asynccontextmanager
from langdetect import detect # Import the langdetect library
from fastapi.middleware.cors import CORSMiddleware

# Suppress warnings for a cleaner output
warnings.filterwarnings("ignore")

# Load environment variables
load_dotenv()
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")
SUPABASE_TABLE = "knowledge_base"

# Global variables for caching models and client
supabase_client = None
embedding_model = None
llm = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initializes models and client at application startup."""
    global supabase_client, embedding_model, llm
    
    # 1. Initialize Supabase client once
    print("Initializing Supabase client...")
    try:
        supabase_client = create_client(SUPABASE_URL, SUPABASE_KEY)
        print("Supabase client initialized successfully.")
    except Exception as e:
        print(f"Failed to initialize Supabase client: {str(e)}")
        supabase_client = None

    # 2. Initialize embedding model once
    print("Loading embedding model...")
    try:
        embedding_model_name = "krutrim-ai-labs/Vyakyarth"
        embedding_model = HuggingFaceEmbeddings(model_name=embedding_model_name)
        print("Embedding model loaded successfully.")
    except Exception as e:
        print(f"Failed to load embedding model: {str(e)}")
        embedding_model = None

    # 3. Initialize LLM once
    print("Loading LlamaCpp LLM model...")
    try:
        model_path = os.path.join(os.getcwd(), "models", "llama-2-7b.Q3_K_M.gguf")
        llm = LlamaCpp(
            model_path=model_path,
            temperature=0.7,
            max_tokens=256,
            n_ctx=4096,
            verbose=False,
        )
        print("LLM loaded successfully.")
    except Exception as e:
        print(f"Failed to load LLM: {str(e)}. Make sure the model path is correct.")
        llm = None

    yield # The application will run here

    # Clean up resources on shutdown
    print("Application is shutting down. Cleaning up...")
    supabase_client = None
    embedding_model = None
    llm = None

# Initialize FastAPI app with the lifespan context
app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For hackathon/demo, allow all
    allow_credentials=True,
    allow_methods=["*"],   # Allow all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],   # Allow all headers
)

# Pydantic model for the request body
class QueryRequest(BaseModel):
    query: str
    language: str = None 

def perform_vector_search(embedding, k: int = 3):
    """
    Performs a vector similarity search on the Supabase table.
    Returns the top k most similar document chunks.
    """
    if not supabase_client:
        raise HTTPException(status_code=503, detail="Database connection not available.")
    
    try:
        response = supabase_client.rpc('match_documents', {
            'query_embedding': embedding,
            'match_count': k
        }).execute()
        
        context = [item['content'] for item in response.data]
        return "\n\n".join(context)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database search failed: {str(e)}")

# Define the RAG prompt template
prompt_template = PromptTemplate.from_template("""
You are a "Digital Krishi Officer," an expert in coconut cultivation in Kerala.
You must answer the user's question accurately and concisely based ONLY on the provided context. 
If the information required to answer the question is not present in the context, simply state: 
"I am sorry, but I cannot answer that question with the information I have." Do not add any other information.

Context: {context}

Question: {question}

Answer in {language}:
""")

@app.post("/query")
async def handle_query(request: QueryRequest):
    """
    API endpoint to handle a user's query for the RAG system.
    """
    if not llm:
        raise HTTPException(status_code=503, detail="LLM not initialized. Please check the model path and installation.")
    if not embedding_model:
        raise HTTPException(status_code=503, detail="Embedding model not initialized. This may be due to a poor internet connection or an incorrect model name. Please check your setup.")

    query = request.query
    
    # 1. Detect the language of the query
    try:
        detected_lang = detect(query)
    except:
        detected_lang = 'en' # Default to English if detection fails
    
    # 2. Determine the response language
    response_lang = detected_lang
    if request.language:
        response_lang = request.language
    elif detected_lang == 'en':
        # Default to Malayalam if the user does not specify a language
        #response_lang = 'ml'
        response_lang = 'en'

    # 3. Embed the user's query
    query_embedding = embedding_model.embed_query(query)
    
    # 4. Perform vector search to get relevant context
    context = perform_vector_search(query_embedding, k=5)
    
    if not context:
        return {"answer": "I could not find any relevant information."}
    
    # 5. Create the final prompt with context
    final_prompt = prompt_template.format(context=context, question=query, language=response_lang)
    
    # 6. Get the answer from the LLM
    try:
        response = llm.invoke(final_prompt)
        return {"answer": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"LLM generation failed: {str(e)}")
    
from fastapi import UploadFile, File
import requests

KINDWISE_API_KEY = os.getenv("KINDWISE_API_KEY")  # set in .env

@app.post("/image_query")
async def handle_image_query(file: UploadFile = File(...), language: str = None):
    """
    Handle image input -> classify using Kindwise -> pass to RAG pipeline
    """
    try:
        # 1. Send image to Kindwise API
        files = {"file": (file.filename, await file.read(), file.content_type)}
        headers = {"Authorization": f"Bearer {KINDWISE_API_KEY}"}
        response = requests.post("https://api.kindwise.com/classify", files=files, headers=headers)

        if response.status_code != 200:
            raise HTTPException(status_code=500, detail=f"Kindwise API failed: {response.text}")

        result = response.json()
        classification_text = result.get("label", "unknown issue")

        # 2. Reuse existing query pipeline
        query_req = QueryRequest(query=classification_text, language=language)
        return await handle_query(query_req)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image processing failed: {str(e)}")
