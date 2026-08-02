import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/palette.dart';
import '../utils/global.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();

    // Check auth status and navigate accordingly after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize global w and height via Media Query
    initScreenSize(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background glow scaled with media query w
          Center(
            child: Container(
              width: w * 0.75,
              height: w * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Cluster
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: 0.1,
                        child: Container(
                          width: w * 0.22,
                          height: w * 0.22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      Container(
                        width: w * 0.2,
                        height: w * 0.2,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.home_rounded,
                          color: AppColors.textLight,
                          size: w * 0.12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                  // App Title using Google Fonts Poppins and AppColors.primary
                  Text(
                    'Constructa',
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: Text(
                      'Build your dream with trusted professionals',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: w * 0.04,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  // Loading Indicator Bar
                  SizedBox(
                    width: w * 0.45,
                    height: height * 0.005,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.surfaceLight,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.06,
            left: 0,
            right: 0,
            child: Text(
              'PRECISION IN ARCHITECTURE',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: w * 0.03,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
