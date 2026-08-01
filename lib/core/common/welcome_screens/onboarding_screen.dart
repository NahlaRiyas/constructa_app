import '../utils/global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/palette.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Find Trusted Construction Companies',
      description: 'Browse verified builders and contractors in Kerala. Your dream project starts here.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBkqiuKAxv7HoeYJt1SjLlKJdpGUxis4ccv6gIDxPUBmLnWAOBORj1N1DkOIb8F-G72v3AThkfWcg2XUTogsD8xBlsAOGcS1wTpPIXEph-9UnYSI2KO3ls13XascaSMdIUOHgwMMrTpYpybNCoPY5O5bJDNuwoca7nkaaUhdMB0lYhZil9pd32auW1vGwVzb5cw8f1hqQKPdq3b4TkkRhMdHlt8xjqU3G_DNiP2ivREKF1Ni6L54AM0',
      badgeTitle: 'Quality Assurance',
      badgeSubtitle: 'ISO Certified Builders',
    ),
    OnboardingData(
      title: 'Compare Plans & Pricing',
      description: 'Get transparent pricing and detailed house blueprints tailored to your construction needs.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDA9ykOdtGDg-1aNLTWQ-i-8BG0tVIXPC4-7c5jhh2diPqlqLZBWRHdEsrGS9ujsGNB1eSWJAfoVtTOKYSCqHddvkKipOIiU9HRny_WcSqPxLByVf9SN9A0VjBvIpxglHAmRR4BPQHcNeef3v9AcrqVpMnnCzU_c9CF5NUVIbOQ61HVZDp7HOS-mk-WTGEEhJkCmrgeQoo8yRP_W4n_gsIBGzTSuehUCjFIhHLIFSezAMaoikkC7Vfh',
      badgeTitle: 'FIXED PRICING',
      badgeSubtitle: 'Smart Estimates',
    ),
    OnboardingData(
      title: 'Book With Confidence',
      description: 'Securely book site visits and track project progress in real-time.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQAmk29PhKr8OlyeDKbBDwr1gbIVINpOX0C68ZEPJO7TK5Ri8cd_7yHGkBl5OflMYw4gzAzK6XGQ-URM6H7Aa9TYqxJKRhKywljwFqqUovhx5ZjNHWtJ7Mv-VQLCZa4bxU3fbWiNSIOlymxMmluyf1BO5PRb51uXX6CHUVzxwDU5mr8kKYu1jliQPR-A_LkOXwCqE0bQBXhuQqDM6qIsSMRsiiKiUrOuNxNnqMQsWo3UGcdp2EBBkX',
      badgeTitle: 'Site Visit Confirmed',
      badgeSubtitle: '10:00 AM • Progress Tracked',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize global w and height via Media Query
    initScreenSize(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Skip Button using AppColors.primary & GoogleFonts.poppins
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text(
                    'SKIP',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Image Container
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(
                                  data.imageUrl,
                                  width: w,
                                  height: height * 0.45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: AppColors.surfaceLight,
                                        child: Icon(Icons.verified, color: AppColors.secondary),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            data.badgeTitle,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            data.badgeSubtitle,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Title using AppColors.primary and GoogleFonts.poppins
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Footer Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primary : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: w,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
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
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;
  final String badgeTitle;
  final String badgeSubtitle;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badgeTitle,
    required this.badgeSubtitle,
  });
}
