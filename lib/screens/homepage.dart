import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'voice_recording_page.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imagePath;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.imagePath,
    required this.timestamp,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _queryController = TextEditingController();
  final String userName = "John"; // This should come from user authentication
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _addMessageToChat("", true, image.path);
      }
    } catch (e) {
      _showError("An error occurred. Sorry, please try again.");
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _addMessageToChat("", true, image.path);
      }
    } catch (e) {
      _showError("An error occurred. Sorry, please try again.");
    }
  }

  Future<void> _openVoiceRecording() async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VoiceRecordingPage(),
        ),
      );
    } catch (e) {
      _showError("An error occurred. Sorry, please try again.");
    }
  }

  void _addMessageToChat(String text, bool isUser, [String? imagePath]) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        imagePath: imagePath,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    _addMessageToChat(message, false);
  }

  Future<void> _sendMessage() async {
    if (_queryController.text.trim().isEmpty) return;

    final userMessage = _queryController.text.trim();
    _queryController.clear();
    
    _addMessageToChat(userMessage, true);
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call - replace with actual backend call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate AI response
      final aiResponse = "Thank you for your question: \"$userMessage\". This is a simulated response from Krishi Mithra. In a real implementation, this would be processed by the backend AI system.";
      _addMessageToChat(aiResponse, false);
    } catch (e) {
      _showError("An error occurred. Sorry, please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/home_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Panel with pesto green color
              Container(
                height: 133,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xFF648134), // Pesto green color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'KRISHI MITHRA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              
              // Icons positioned below the top panel
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF648134), // Pesto green color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF648134), // Pesto green color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content Area
              Expanded(
                child: _messages.isEmpty
                    ? _buildWelcomeMessage()
                    : _buildChatLog(),
              ),
              
              // Input Bar
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF648134).withOpacity(0.1), // Light pesto green background
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFF648134), width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _queryController,
                          decoration: const InputDecoration(
                            hintText: 'Ask Krishi Mithra',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      // Camera Icon
                      IconButton(
                        onPressed: _takePhoto,
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      // Gallery Icon
                      IconButton(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      // Voice Icon
                      IconButton(
                        onPressed: _openVoiceRecording,
                        icon: const Icon(
                          Icons.mic_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      // Send Button
                      IconButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Color(0xFF648134),
                                size: 24,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          
          // Greeting Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'നമസ്കാരം, ',
                    style: TextStyle(
                      color: const Color(0xFF648134),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: userName,
                    style: TextStyle(
                      color: const Color(0xFF648134),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildChatLog() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatBubble(message);
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser 
              ? const Color(0xFF648134).withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(message.imagePath!),
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}