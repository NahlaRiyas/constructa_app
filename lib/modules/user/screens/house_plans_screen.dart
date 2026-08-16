import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import 'house_plan_detail_screen.dart';

class HousePlansScreen extends StatefulWidget {
  const HousePlansScreen({super.key});

  @override
  State<HousePlansScreen> createState() => _HousePlansScreenState();
}

class _HousePlansScreenState extends State<HousePlansScreen> {
  String _selectedBhk = 'All';

  final List<String> _bhkFilters = ['All', '2BHK', '3BHK', '4BHK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Explore House Plans', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 18)),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            color: AppColors.cardBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _bhkFilters.map((bhk) {
                  final isSelected = _selectedBhk == bhk;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(bhk, style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 13)),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceLight,
                      onSelected: (val) => setState(() => _selectedBhk = bhk),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // House Plans Grid
          Expanded(
            child: StreamBuilder<List<HousePlanModel>>(
              stream: HousePlanService().getHousePlans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var plans = snapshot.data ?? [];
                if (_selectedBhk != 'All') {
                  plans = plans.where((p) => p.bhk.toUpperCase() == _selectedBhk.toUpperCase()).toList();
                }

                if (plans.isEmpty) {
                  return Center(
                    child: Text('No house plans found for $_selectedBhk.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: plans.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return _buildPlanCard(context, plan);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, HousePlanModel plan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HousePlanDetailScreen(plan: plan)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowColor, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (plan.tag.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          plan.tag.toUpperCase(),
                          style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text('${plan.bhk} • ${plan.sqft} sq.ft', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '₹${(plan.contractPrice/100000).toStringAsFixed(1)} Lakhs',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
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
