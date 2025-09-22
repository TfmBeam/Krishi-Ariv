import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const KrishiMithraApp());
}

class KrishiMithraApp extends StatelessWidget {
  const KrishiMithraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishi Mithra',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF4A7C59), // Olive green color
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
