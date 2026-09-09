import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Pages UI/UX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFF0E6F6),
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF3D2C4E),
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D2C4E),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
