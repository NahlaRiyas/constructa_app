import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';

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
            Text('Inspect architectural designs, blueprints, and manage listings', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
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
                    width: 850,
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
            decoration:  BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                 SizedBox(width: 60, child: Text('Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: Text('Plan Title', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Company', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('BHK', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Sq.Ft', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Price', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Tag', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 90),
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

    return InkWell(
      onTap: () => _showPlanDetailsDialog(context, plan),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration:  BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
        ),
        child: Row(
          children: [
            // Thumbnail with count badge
            SizedBox(
              width: 60,
              height: 46,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: plan.imageUrls.isNotEmpty
                        ? Image.network(
                            plan.imageUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceLight, child: const Icon(Icons.broken_image, size: 20)),
                          )
                        : Container(color: AppColors.surfaceLight, child: const Icon(Icons.architecture, size: 20, color: AppColors.primary)),
                  ),
                  if (plan.imageUrls.length > 1)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${plan.imageUrls.length}',
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

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
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(plan.tag, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor)),
                      ),
                    )
                  : const SizedBox(),
            ),

            // Actions: View & Delete
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 19, color: AppColors.primary),
                    onPressed: () => _showPlanDetailsDialog(context, plan),
                    tooltip: 'View Plan & Blueprints',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 19, color: AppColors.statusDanger),
                    onPressed: () => _confirmDelete(context, plan),
                    tooltip: 'Delete Plan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlanDetailsDialog(BuildContext context, HousePlanModel plan) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 680),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        plan.title,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text('Designed & Built by ${plan.companyName}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 14),

                // Blueprints & 3D Photos Section
                if (plan.imageUrls.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Blueprints & 3D Renders (${plan.imageUrls.length})',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.fullscreen, size: 16, color: AppColors.primary),
                        label: Text('Open Full Gallery', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary)),
                        onPressed: () {
                          FullscreenImageViewer.open(
                            context,
                            imageUrls: plan.imageUrls,
                            title: plan.title,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: plan.imageUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            FullscreenImageViewer.open(
                              context,
                              imageUrls: plan.imageUrls,
                              initialIndex: idx,
                              title: plan.title,
                            );
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.network(
                                plan.imageUrls[idx],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${plan.bhk} • ${plan.sqft} sq.ft', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const Spacer(),
                            Text(
                              '₹${(plan.contractPrice / 100000).toStringAsFixed(2)} Lakhs',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Plan Description', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(
                          plan.description.isNotEmpty ? plan.description : 'No description provided.',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                        ),
                        if (plan.features.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text('Features & Specs', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: plan.features.map((f) {
                              return Chip(
                                label: Text(f, style: GoogleFonts.poppins(fontSize: 11)),
                                backgroundColor: AppColors.surfaceLight,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
