import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import 'house_plan_detail_screen.dart';

/// HousePlansScreen
///
/// Browseable house plan catalog with category filters and interactive grid cards.
/// Employs MediaQuery for dynamic responsive layout sizing across screen sizes.
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
    // MediaQuery Responsive Layout Sizing
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double vPadding = (h * 0.015).clamp(8.0, 16.0);
    final double appBarTitleFontSize = (w * 0.045).clamp(16.0, 22.0);
    final double chipFontSize = (w * 0.033).clamp(11.0, 15.0);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(context), size: (w * 0.06).clamp(20.0, 28.0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Explore House Plans',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
            fontSize: appBarTitleFontSize,
          ),
        ),
      ),
      body: Column(
        children: [
          // Animated Choice Filter Chips Row
          Container(
            color: AppColors.getCardBackground(context),
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _bhkFilters.map((bhk) {
                  final isSelected = _selectedBhk == bhk;
                  return Padding(
                    padding: EdgeInsets.only(right: w * 0.02),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: ChoiceChip(
                        selected: isSelected,
                        label: Text(
                          bhk,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : AppColors.getTextPrimary(context),
                            fontSize: chipFontSize,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.getSurfaceLight(context),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.05)),
                        onSelected: (val) => setState(() => _selectedBhk = bhk),
                      ),
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
                  plans = plans
                      .where((p) => p.bhk.toUpperCase() == _selectedBhk.toUpperCase())
                      .toList();
                }

                if (plans.isEmpty) {
                  return Center(
                    child: Text(
                      'No house plans found for $_selectedBhk.',
                      style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: chipFontSize),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(hPadding),
                  itemCount: plans.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: w > 600 ? 3 : 2,
                    crossAxisSpacing: w * 0.03,
                    mainAxisSpacing: h * 0.018,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return _buildAnimatedPlanCard(context, plan, index, w, h);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Renders house plan cards with staggered scale & fade entrance animation using MediaQuery dimensions.
  Widget _buildAnimatedPlanCard(BuildContext context, HousePlanModel plan, int index, double w, double h) {
    final double cardTitleFontSize = (w * 0.033).clamp(11.0, 15.0);
    final double cardSubTitleFontSize = (w * 0.028).clamp(10.0, 13.0);
    final double priceFontSize = (w * 0.033).clamp(11.0, 15.0);
    final double borderRadius = (w * 0.04).clamp(12.0, 18.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.92 + (0.08 * value),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HousePlanDetailScreen(plan: plan)),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.getCardBackground(context),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: AppColors.getBorderLight(context)),
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
                            borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
                            child: Image.network(
                              plan.imageUrls.isNotEmpty
                                  ? plan.imageUrls.first
                                  : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (plan.tag.isNotEmpty)
                            Positioned(
                              top: h * 0.01,
                              right: w * 0.02,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.005),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(w * 0.02),
                                ),
                                child: Text(
                                  plan.tag.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: (w * 0.022).clamp(8.0, 11.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: cardTitleFontSize, color: AppColors.getTextPrimary(context)),
                          ),
                          SizedBox(height: h * 0.002),
                          Text(
                            '${plan.bhk} • ${plan.sqft} sq.ft',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: cardSubTitleFontSize, color: AppColors.getTextSecondary(context)),
                          ),
                          SizedBox(height: h * 0.004),
                          Text(
                            '₹${(plan.contractPrice / 100000).toStringAsFixed(1)} Lakhs',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: priceFontSize, color: AppColors.primary),
                          ),
                        ],
                      ),
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
}
