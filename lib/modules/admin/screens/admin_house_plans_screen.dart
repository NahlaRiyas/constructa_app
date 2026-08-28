import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/admin_service.dart';

class AdminHousePlansScreen extends StatelessWidget {
  const AdminHousePlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage House Plans', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('View and manage all house plans across the platform', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            StreamBuilder<List<HousePlanModel>>(
              stream: AdminService().getAllHousePlans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error loading house plans: ${snapshot.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                    ),
                  );
                }
                final plans = snapshot.data ?? [];
                if (plans.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text('No house plans found.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 750,
                    child: _buildPlansTable(context, plans),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansTable(BuildContext context, List<HousePlanModel> plans) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Plan Title', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Company', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('BHK', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Sq.Ft', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Price', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Tag', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 50),
              ],
            ),
          ),
          ...plans.map((plan) => _buildPlanRow(context, plan)),
        ],
      ),
    );
  }

  Widget _buildPlanRow(BuildContext context, HousePlanModel plan) {
    Color tagColor = AppColors.textSecondary;
    if (plan.tag == 'Bestseller') tagColor = AppColors.tagBestseller;
    if (plan.tag == 'Trending') tagColor = AppColors.tagTrending;
    if (plan.tag == 'New') tagColor = AppColors.tagNew;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(plan.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(plan.companyName, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(plan.bhk, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary)),
          ),
          Expanded(
            child: Text('${plan.sqft}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary)),
          ),
          Expanded(
            child: Text('₹${(plan.contractPrice / 100000).toStringAsFixed(1)}L', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
          Expanded(
            child: plan.tag.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(plan.tag, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor)),
                  )
                : const SizedBox(),
          ),
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusDanger),
              onPressed: () => _confirmDelete(context, plan),
              tooltip: 'Delete Plan',
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, HousePlanModel plan) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete House Plan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${plan.title}"?', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              await AdminService().deleteHousePlan(plan.id);
              if (context.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plan "${plan.title}" deleted.')));
              }
            },
            child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.statusDanger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
