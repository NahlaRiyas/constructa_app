import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import 'book_service_screen.dart';

class HousePlanDetailScreen extends StatelessWidget {
  final HousePlanModel plan;
  const HousePlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(plan.bhk, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${plan.sqft} sq.ft', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(plan.title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  if (plan.companyName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Designed & Built by ${plan.companyName}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 16),

                  // Contract Price Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Contract Price', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              '₹${(plan.contractPrice/100000).toStringAsFixed(2)} Lakhs',
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text('Overview & Architecture', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    plan.description.isNotEmpty
                        ? plan.description
                        : 'Custom architectural plan engineered for optimal space utilization, modern structural aesthetics, and efficient construction timeline.',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  if (plan.features.isNotEmpty) ...[
                    Text('Key Features & Specifications', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plan.features.map((feat) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: AppColors.statusSuccess),
                              const SizedBox(width: 6),
                              Text(feat, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookServiceScreen(
                    companyId: plan.companyId,
                    companyName: plan.companyName,
                    planId: plan.id,
                    planTitle: plan.title,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Book Construction Service', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
