import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../utils/global.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize global w and height via MediaQuery
    initScreenSize(context);

    // Dynamic responsive dimensions using MediaQuery
    final double horizontalPadding = w > 400 ? 20.0 : 14.0;
    final double headerFontSize = w > 360 ? 18.0 : 16.0;
    final double cardImageSize = w > 360 ? 85.0 : 70.0;

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = user?.fullName.split(' ').first ?? 'User';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            title: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: GoogleFonts.poppins(fontSize: w > 360 ? 11 : 10, color: AppColors.textSecondary)),
                    Text(displayName, style: GoogleFonts.poppins(fontSize: w > 360 ? 16 : 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive Search Bar
            TextField(
              style: GoogleFonts.poppins(fontSize: w > 360 ? 13 : 12, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search contractors, plans, or services...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: w > 360 ? 13 : 12),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(vertical: w > 360 ? 14 : 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),

            // Responsive Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    selected: true,
                    label: Text('Construction', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: w > 360 ? 12 : 11, fontWeight: FontWeight.bold)),
                    onSelected: (val) {},
                    selectedColor: AppColors.primary,
                    avatar: const Icon(Icons.construction, color: AppColors.textLight, size: 16),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text('Renovation', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: w > 360 ? 12 : 11)),
                    onSelected: (val) {},
                    backgroundColor: AppColors.cardBackground,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text('Interior', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: w > 360 ? 12 : 11)),
                    onSelected: (val) {},
                    backgroundColor: AppColors.cardBackground,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.025),

            // Responsive Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top Rated Companies', style: GoogleFonts.poppins(fontSize: headerFontSize, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Responsive Card
            Card(
              color: AppColors.cardBackground,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(w > 360 ? 14 : 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
                        width: cardImageSize,
                        height: cardImageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BuildWell Constructions', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w > 360 ? 15 : 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.starRating, size: 16),
                              Text(' 4.9 ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                              Text('(124 reviews)', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                              Text(' Kochi, Kerala', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                            ],
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: AppColors.primary,
      //   child: const Icon(Icons.add, color: AppColors.textLight),
      // ),
        );
      },
    );
  }
}
