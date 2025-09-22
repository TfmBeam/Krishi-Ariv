import os
import warnings
from dotenv import load_dotenv
from supabase.client import create_client, Client
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings import HuggingFaceEmbeddings

# Suppress all warnings for a cleaner output
warnings.filterwarnings("ignore")

# Load environment variables for Supabase credentials
load_dotenv()
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")
SUPABASE_TABLE = "knowledge_base"  # The name of our table

def get_supabase_client() -> Client:
    """Initializes and returns a Supabase client."""
    # Debugging prints to confirm variables are loaded
    print(f"Loading URL: {SUPABASE_URL}")
    print(f"Loading Key: {SUPABASE_KEY}")
    return create_client(SUPABASE_URL, SUPABASE_KEY)

def load_documents_from_folder(folder_path: str):
    """Loads all PDF documents from a specified folder."""
    documents = []
    print("Loading documents from folder...")
    for filename in os.listdir(folder_path):
        if filename.endswith(".pdf"):
            file_path = os.path.join(folder_path, filename)
            loader = PyPDFLoader(file_path)
            documents.extend(loader.load())
    print(f"Successfully loaded {len(documents)} document pages from {folder_path}.")
    return documents

def split_documents(documents):
    """Splits documents into smaller, manageable chunks."""
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    return text_splitter.split_documents(documents)

def create_embeddings_and_store(chunks):
    """
    Creates embeddings for each chunk and stores them in Supabase.
    Uses a multilingual model to handle both Malayalam and English.
    """
    print("Creating embeddings and storing in Supabase...")

    embedding_model_name = "krutrim-ai-labs/Vyakyarth"
    embeddings = HuggingFaceEmbeddings(model_name=embedding_model_name)
    supabase_client = get_supabase_client()

    for i, chunk in enumerate(chunks):
        content = chunk.page_content
        embedding = embeddings.embed_query(content)

        supabase_client.from_(SUPABASE_TABLE).insert({
            "content": content,
            "embedding": embedding
        }).execute()
        
        if (i + 1) % 50 == 0:
            print(f"Ingested {i+1} of {len(chunks)} chunks.")

    print("\nEmbedding and storage process complete!")

if __name__ == "__main__":
    data_folder_path = "data"
    docs = load_documents_from_folder(data_folder_path)
    text_chunks = split_documents(docs)
    create_embeddings_and_store(text_chunks)