import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../utils/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    // Navigate to Onboarding Screen after 2.8s
    _navigationTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001233), // Deep Navy Midnight
              Color(0xFF003178), // Primary Brand Blue
              Color(0xFF002255), // Dark Blue Base
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Pulse Glow Circle
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: w * 0.72,
                height: w * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.lightBlueAccent.withValues(alpha: 0.08),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Main Brand Logo Cluster & Typography
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Layered Rotated Architectural Logo Card
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: 0.12,
                            child: Container(
                              width: w * 0.23,
                              height: w * 0.23,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(w * 0.06),
                              ),
                            ),
                          ),
                          Container(
                            width: w * 0.22,
                            height: w * 0.22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(w * 0.055),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.home_work_rounded,
                                size: w * 0.12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.04),

                    Text(
                      'CONSTRUCTA',
                      style: GoogleFonts.poppins(
                        fontSize: w * 0.085,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.012),

                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.04, vertical: height * 0.008),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(w * 0.05),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        'DIGITAL ARCHITECTURE & CONTRACTOR PLATFORM',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.025,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.06),

                    SizedBox(
                      width: w * 0.38,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: height * 0.04,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'v1.0.0 • POWERED BY CONSTRUCTA ENGINE',
                  style: GoogleFonts.poppins(
                    fontSize: w * 0.026,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
