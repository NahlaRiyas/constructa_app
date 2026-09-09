import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

/// ============================================================================
/// FILE: onboarding_screen.dart
/// MODULE: Authentication & Welcome Flow (Onboarding UI Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Interactive 4-slide onboarding page enforcing clean Light Theme styling.
///   Demonstrates app capabilities, house plan comparisons, contractor
///   booking, and live site tracking before redirecting to AuthWrapper / Login.
/// ============================================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Find Verified Builders & Architects',
      description:
          'Browse top-rated construction companies and verified builders. Your dream home starts with trusted professionals.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBkqiuKAxv7HoeYJt1SjLlKJdpGUxis4ccv6gIDxPUBmLnWAOBORj1N1DkOIb8F-G72v3AThkfWcg2XUTogsD8xBlsAOGcS1wTpPIXEph-9UnYSI2KO3ls13XascaSMdIUOHgwMMrTpYpybNCoPY5O5bJDNuwoca7nkaaUhdMB0lYhZil9pd32auW1vGwVzb5cw8f1hqQKPdq3b4TkkRhMdHlt8xjqU3G_DNiP2ivREKF1Ni6L54AM0',
      badgeIcon: Icons.verified_user_rounded,
      badgeTitle: 'Quality Assurance',
      badgeSubtitle: 'ISO Certified Contractors',
    ),
    OnboardingSlideData(
      title: 'Explore 2D/3D House Plans',
      description:
          'Discover modern floor plans, structural blueprints, and pre-calculated construction cost estimates.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA9ykOdtGDg-1aNLTWQ-i-8BG0tVIXPC4-7c5jhh2diPqlqLZBWRHdEsrGS9ujsGNB1eSWJAfoVtTOKYSCqHddvkKipOIiU9HRny_WcSqPxLByVf9SN9A0VjBvIpxglHAmRR4BPQHcNeef3v9AcrqVpMnnCzU_c9CF5NUVIbOQ61HVZDp7HOS-mk-WTGEEhJkCmrgeQoo8yRP_W4n_gsIBGzTSuehUCjFIhHLIFSezAMaoikkC7Vfh',
      badgeIcon: Icons.architecture_rounded,
      badgeTitle: 'Transparent Pricing',
      badgeSubtitle: 'Smart Cost Calculator',
    ),
    OnboardingSlideData(
      title: 'Book Consultations & Site Visits',
      description:
          'Schedule on-site consultations and site visits directly with verified contractors at your convenient date and time.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQAmk29PhKr8OlyeDKbBDwr1gbIVINpOX0C68ZEPJO7TK5Ri8cd_7yHGkBl5OflMYw4gzAzK6XGQ-URM6H7Aa9TYqxJKRhKywljwFqqUovhx5ZjNHWtJ7Mv-VQLCZa4bxU3fbWiNSIOlymxMmluyf1BO5PRb51uXX6CHUVzxwDU5mr8kKYu1jliQPR-A_LkOXwCqE0bQBXhuQqDM6qIsSMRsiiKiUrOuNxNnqMQsWo3UGcdp2EBBkX',
      badgeIcon: Icons.event_available_rounded,
      badgeTitle: 'Instant Confirmation',
      badgeSubtitle: 'Direct Contractor Dialing',
    ),
    OnboardingSlideData(
      title: 'Track Construction Progress Live',
      description:
          'Manage client inquiries, showcase completed project portfolios, and track active bookings in one unified console.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
      badgeIcon: Icons.business_rounded,
      badgeTitle: 'Unified Console',
      badgeSubtitle: 'Live Progress Tracker',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToHomeOrAuth();
    }
  }

  void _navigateToHomeOrAuth() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Dimension Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    // Enforce Light Theme ThemeOverride on Onboarding
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightCardBackground,
      ),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Header Bar with SKIP Action Button
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05, vertical: h * 0.01),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToHomeOrAuth,
                    child: Text(
                      'SKIP',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.035,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              // Main Interactive PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        children: [
                          // Animated Hero Image & Badge Container
                          Expanded(
                            child: Stack(
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                      begin: 0.9,
                                      end: _currentPage == index ? 1.0 : 0.9),
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutBack,
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(w * 0.06),
                                        child: Image.network(
                                          slide.imageUrl,
                                          width: w,
                                          height: h * 0.42,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: AppColors.lightSurfaceLight,
                                            child: Icon(
                                              Icons.construction,
                                              size: w * 0.2,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: h * 0.015,
                                  left: w * 0.03,
                                  right: w * 0.03,
                                  child: Container(
                                    padding: EdgeInsets.all(w * 0.03),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightCardBackground
                                          .withValues(alpha: 0.94),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.04),
                                      border: Border.all(
                                          color: AppColors.lightBorderLight),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.12),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: w * 0.05,
                                          backgroundColor:
                                              AppColors.lightSurfaceLight,
                                          child: Icon(slide.badgeIcon,
                                              color: AppColors.primary,
                                              size: w * 0.05),
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                slide.badgeTitle.toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: w * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              Text(
                                                slide.badgeSubtitle,
                                                style: GoogleFonts.poppins(
                                                  fontSize: w * 0.032,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightTextPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.025),

                          // Slide Title
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.058,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: h * 0.012),

                          // Slide Subtitle / Description
                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.033,
                              color: AppColors.lightTextSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Footer Section: Page Indicator Dots & Action Button
              Padding(
                padding: EdgeInsets.all(w * 0.06),
                child: Column(
                  children: [
                    // Animated Page Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? AppColors.primary
                                : AppColors.lightBorderLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    // Next / Get Started Main Button
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.062,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.035),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _slides.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: GoogleFonts.poppins(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Icon(
                              _currentPage == _slides.length - 1
                                  ? Icons.rocket_launch_rounded
                                  : Icons.arrow_forward_rounded,
                              size: w * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final String imageUrl;
  final IconData badgeIcon;
  final String badgeTitle;
  final String badgeSubtitle;

  OnboardingSlideData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badgeIcon,
    required this.badgeTitle,
    required this.badgeSubtitle,
  });
}
