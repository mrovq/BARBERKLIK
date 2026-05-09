import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup fade-in animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds fade-in
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to Home Screen after delay
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background #000000
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for Logo (using an icon since image is not yet available)
              const Icon(
                Icons.content_cut, // Scissor icon fitting for a barber
                size: 80,
                color: Color(0xFFD4AF37), // Metallic Gold #D4AF37
              ),
              const SizedBox(height: 20),
              // Nama Aplikasi
              const Text(
                'BARBERKLIK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              // Slogan
              Text(
                'Premium Barbershop',
                style: TextStyle(
                  color: const Color(0xFFD4AF37).withOpacity(0.8), // Metallic Gold with opacity
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
