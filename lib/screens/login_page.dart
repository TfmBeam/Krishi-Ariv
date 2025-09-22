import 'package:flutter/material.dart';
import 'dart:math';
import 'mobile_number_input_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Top Green Section with curved bottom
            Expanded(
              flex: 5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B8E23), // Olive green
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: const Center(
                    child: FloralDrawing(),
                  ),
                ),
              ),
            ),
            // Bottom White Section
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Text
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Color(0xFF6B8E23),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // KRISHIARIV Text
                    const Text(
                      'KRISHIARIV',
                      style: TextStyle(
                        color: Color(0xFF6B8E23),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    // Forward Arrow Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B8E23),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MobileNumberInputPage(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for curved bottom edge
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Start from top-left
    path.moveTo(0, 0);
    
    // Go to top-right
    path.lineTo(size.width, 0);
    
    // Go to bottom-right with slight curve
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.7,
      size.width * 0.7,
      size.height * 0.9,
    );
    
    // Create the main wave curve
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.1,
      size.width * 0.3,
      size.height * 0.9,
    );
    
    // Complete the curve to bottom-left
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.7,
      0,
      size.height * 0.85,
    );
    
    // Close the path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Floral Drawing Widget
class FloralDrawing extends StatelessWidget {
  const FloralDrawing({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: FloralPainter(),
    );
  }
}

class FloralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Draw petals around the center
    for (int i = 0; i < 6; i++) {
      final angle = (i * 2 * pi) / 6;
      final petalCenter = Offset(
        center.dx + radius * 0.7 * cos(angle - pi / 2),
        center.dy + radius * 0.7 * sin(angle - pi / 2),
      );
      
      // Draw petal as an oval
      canvas.drawOval(
        Rect.fromCenter(
          center: petalCenter,
          width: radius * 0.6,
          height: radius * 0.8,
        ),
        paint,
      );
    }

    // Draw center circle
    canvas.drawCircle(center, radius * 0.2, paint);

    // Draw stem
    canvas.drawLine(
      Offset(center.dx, center.dy + radius * 0.5),
      Offset(center.dx, center.dy + radius * 1.2),
      paint,
    );

    // Draw leaves
    final leaf1 = Offset(center.dx - radius * 0.3, center.dy + radius * 0.8);
    final leaf2 = Offset(center.dx + radius * 0.3, center.dy + radius * 0.8);
    
    canvas.drawOval(
      Rect.fromCenter(center: leaf1, width: radius * 0.4, height: radius * 0.3),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: leaf2, width: radius * 0.4, height: radius * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
