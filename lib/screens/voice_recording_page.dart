import 'package:flutter/material.dart';
import 'dart:async';

class VoiceRecordingPage extends StatefulWidget {
  const VoiceRecordingPage({super.key});

  @override
  State<VoiceRecordingPage> createState() => _VoiceRecordingPageState();
}

class _VoiceRecordingPageState extends State<VoiceRecordingPage>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start recording automatically when page opens
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    
    _pulseController.repeat(reverse: true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    
    _pulseController.stop();
    _timer?.cancel();
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recording Complete'),
          content: Text('Recording duration: ${_formatTime(_seconds)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to homepage
              },
              child: const Text('Discard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to homepage
                // Here you would typically send the recording to the backend
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recording sent successfully!'),
                    backgroundColor: Color(0xFF4A7C59),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                foregroundColor: Colors.white,
              ),
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Timer Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Microphone Icon with Animation
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : const Color(0xFF4A7C59),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.red : const Color(0xFF4A7C59))
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Status Text
            Text(
              _isRecording ? 'Listening... Tap to stop recording' : 'Tap to start recording',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 60),
            
            // Sound Wave Animation (Visual indicator)
            if (_isRecording) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 4,
                    height: 20 + (index * 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ],
            
            const Spacer(),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  
                  // Stop/Send Button
                  ElevatedButton(
                    onPressed: _isRecording ? _stopRecording : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.red : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _isRecording ? 'Stop Recording' : 'Start Recording',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
