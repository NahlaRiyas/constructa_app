import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import 'add_edit_house_plan_screen.dart';

class ManageHousePlansScreen extends StatelessWidget {
  const ManageHousePlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? 'comp_1';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'Manage House Plans',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.secondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditHousePlanScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HousePlanModel>>(
        stream: HousePlanService().getCompanyHousePlans(companyUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final plans = snapshot.data ?? [];
          if (plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.architecture, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text('No house plans listed yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEditHousePlanScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text('Add Your First House Plan', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                            Text('${plan.bhk} • ${plan.sqft} sq.ft', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text('₹${(plan.contractPrice/100000).toStringAsFixed(1)} Lakhs', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddEditHousePlanScreen(plan: plan)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.statusDanger),
                        onPressed: () async {
                          await HousePlanService().deleteHousePlan(plan.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('House plan deleted.')));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditHousePlanScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
