import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
          secondary: Color(0xFFD4AF37), // Metallic Gold
          surface: Color(0xFF121212), // Slightly lighter black for surfaces/cards
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFD4AF37),
          elevation: 0,
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
