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
      backgroundColor: const Color(0xFF0A0A0A), // Luxury solid black background
      body: Stack(
        children: [
          // Centered branding and logo
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Elegant glowing logo container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37), // Golden border
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.3), // Gold outer glow
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.content_cut,
                        color: Color(0xFFD4AF37), // Golden scissor icon
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title: BARBERKLIK
                  const Text(
                    'BARBERKLIK',
                    style: TextStyle(
                      fontFamily: 'Montserrat', // Premium sans-serif font
                      color: Color(0xFFD4AF37), // Metallic gold
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle: EXECUTIVE GROOMING
                  Text(
                    'EXECUTIVE GROOMING',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white70, // White with opacity
                      fontSize: 12,
                      fontWeight: FontWeight.w300, // Light font weight
                      letterSpacing: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned Footer
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thin elegant golden divider
                  const SizedBox(
                    width: 180, // Narrow elegant width
                    child: Divider(
                      color: Color(0xFFD4AF37), // Gold divider
                      thickness: 0.5, // Ultra-thin line
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Established text
                  const Text(
                    'EST. 2026',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey, // Grey color
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

