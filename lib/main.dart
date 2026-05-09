import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BarberKlikApp());
}

class BarberKlikApp extends StatelessWidget {
  const BarberKlikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BARBERKLIK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // Metallic Gold
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
