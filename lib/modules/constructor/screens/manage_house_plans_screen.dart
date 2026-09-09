import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';
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
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.secondary),
            tooltip: 'Add New Plan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEditHousePlanScreen()),
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
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.architecture,
                              size: 54, color: AppColors.secondary),
                        ),
                        const SizedBox(height: 16),
                        Text('No house plans listed yet.',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Text(
                            'Publish 2D / 3D architectural plans to attract homebuilders.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddEditHousePlanScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text('Add Your First House Plan',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return _buildAnimatedPlanCard(context, plan, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddEditHousePlanScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New Plan',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  /// Renders individual house plan cards with entrance slide and fade animation.
  Widget _buildAnimatedPlanCard(
      BuildContext context, HousePlanModel plan, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 24),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 6,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (plan.imageUrls.isNotEmpty) {
                          FullscreenImageViewer.open(
                            context,
                            imageUrls: plan.imageUrls,
                            title: plan.title,
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: plan.imageUrls.isNotEmpty
                                ? Image.network(
                                    plan.imageUrls.first,
                                    width: 88,
                                    height: 88,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 88,
                                      height: 88,
                                      color: AppColors.surfaceLight,
                                      child: const Icon(Icons.broken_image,
                                          color: AppColors.textMuted),
                                    ),
                                  )
                                : Container(
                                    width: 88,
                                    height: 88,
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.architecture,
                                        color: AppColors.secondary),
                                  ),
                          ),
                          if (plan.imageUrls.length > 1)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${plan.imageUrls.length}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textPrimary)),
                          Text('${plan.bhk} • ${plan.sqft} sq.ft',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                              '₹${(plan.contractPrice / 100000).toStringAsFixed(1)} Lakhs',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.secondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.primary),
                      tooltip: 'Edit Plan',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddEditHousePlanScreen(plan: plan)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.statusDanger),
                      tooltip: 'Delete Plan',
                      onPressed: () => _confirmDelete(context, plan),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, HousePlanModel plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete House Plan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${plan.title}"?',
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await HousePlanService().deleteHousePlan(plan.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('House plan deleted successfully.')));
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.statusDanger)),
          ),
        ],
      ),
    );
  }
}
