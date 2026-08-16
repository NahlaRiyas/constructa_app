import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/company_service.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/common/utils/global.dart';
import 'company_detail_screen.dart';
import 'house_plan_detail_screen.dart';
import 'house_plans_screen.dart';
import 'book_service_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String _selectedCategory = 'Construction';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Construction', 'icon': Icons.construction},
    {'label': 'Renovation', 'icon': Icons.home_repair_service},
    {'label': 'Interior', 'icon': Icons.chair},
    {'label': 'Plumbing', 'icon': Icons.plumbing},
    {'label': 'Electrical', 'icon': Icons.electrical_services},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  // Interactive Cost Calculator Dialog
  void _showCostCalculatorModal(BuildContext context) {
    double sqft = 2000;
    String quality = 'Standard';
    double ratePerSqft = 2000;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalCost = sqft * ratePerSqft;
            final materialCost = totalCost * 0.60;
            final laborCost = totalCost * 0.30;
            final finishingCost = totalCost * 0.10;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Construction Cost Calculator', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text('Built-up Area: ${sqft.toInt()} sq.ft', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                  Slider(
                    value: sqft,
                    min: 500,
                    max: 5000,
                    divisions: 45,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => sqft = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  Text('Construction Quality Grade', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildQualityChip('Standard (₹2,000/sqft)', quality == 'Standard', () {
                        setModalState(() {
                          quality = 'Standard';
                          ratePerSqft = 2000;
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildQualityChip('Premium (₹2,600/sqft)', quality == 'Premium', () {
                        setModalState(() {
                          quality = 'Premium';
                          ratePerSqft = 2600;
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cost Breakdown Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Estimated Total', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                            Text('₹${(totalCost / 100000).toStringAsFixed(2)} Lakhs', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
                          ],
                        ),
                        const Divider(height: 16),
                        _buildCostRow('Raw Materials (60%)', '₹${(materialCost / 100000).toStringAsFixed(2)} L'),
                        _buildCostRow('Labor & Skilled Work (30%)', '₹${(laborCost / 100000).toStringAsFixed(2)} L'),
                        _buildCostRow('Permits & Finishing (10%)', '₹${(finishingCost / 100000).toStringAsFixed(2)} L'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookServiceScreen(
                              planTitle: '${sqft.toInt()} sq.ft $quality Grade House',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Book Consultation with Estimate', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQualityChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          Text(val, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  // Interactive Virtual Tour Gallery Modal
  void _showVirtualTourModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('3D Virtual Tour Viewer', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Immersive 360° virtual walkthrough experience. Tap explore to inspect room layouts, lighting simulations, and interior dimensions.',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HousePlansScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Browse All 3D Plans', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);
    final double horizontalPadding = w * 0.05;

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = user?.fullName.isNotEmpty == true ? user!.fullName.split(' ').first : 'Rahul';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            titleSpacing: horizontalPadding,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryContainer, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(
                        user?.profileImageUrl.isNotEmpty == true
                            ? user!.profileImageUrl
                            : 'https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(), style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                    Text(displayName, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: horizontalPadding),
                child: IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLight),
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications: You have 0 pending notifications.')),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic Search Bar
                TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search for contractors, plans, or services...',
                    hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final bool isSelected = _selectedCategory == cat['label'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          showCheckmark: false,
                          selected: isSelected,
                          avatar: Icon(cat['icon'] as IconData, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
                          label: Text(
                            cat['label'] as String,
                            style: GoogleFonts.inter(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? AppColors.primary : AppColors.borderLight),
                          ),
                          onSelected: (val) {
                            setState(() => _selectedCategory = cat['label'] as String);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 28),

                // Dynamic Top Rated Companies Header & List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Rated Companies', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/companies'),
                      child: Text('View All', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                StreamBuilder<List<CompanyModel>>(
                  stream: CompanyService().getCompanies(),
                  builder: (context, companySnap) {
                    var companies = companySnap.data ?? [];

                    // Apply Search Query & Category Filter Dynamically
                    if (_searchQuery.isNotEmpty) {
                      companies = companies.where((c) {
                        return c.name.toLowerCase().contains(_searchQuery) ||
                            c.specialty.toLowerCase().contains(_searchQuery) ||
                            c.location.toLowerCase().contains(_searchQuery);
                      }).toList();
                    } else if (_selectedCategory != 'Construction') {
                      companies = companies.where((c) {
                        return c.specialty.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
                            c.services.any((s) => s.toLowerCase().contains(_selectedCategory.toLowerCase()));
                      }).toList();
                    }

                    if (companies.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text('No companies match "$_selectedCategory" search.', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13)),
                        ),
                      );
                    }

                    return Column(
                      children: companies.take(2).map((comp) => _buildCompanyCard(context, comp)).toList(),
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Dynamic Popular House Plans Header & Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular House Plans', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HousePlansScreen()),
                        );
                      },
                      child: Text('Explore', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                StreamBuilder<List<HousePlanModel>>(
                  stream: HousePlanService().getHousePlans(),
                  builder: (context, planSnap) {
                    var plans = planSnap.data ?? [];

                    // Dynamic Filter for Plans
                    if (_searchQuery.isNotEmpty) {
                      plans = plans.where((p) {
                        return p.title.toLowerCase().contains(_searchQuery) ||
                            p.bhk.toLowerCase().contains(_searchQuery) ||
                            p.companyName.toLowerCase().contains(_searchQuery);
                      }).toList();
                    }

                    if (plans.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text('No house plans match search.', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13)),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plans.length > 2 ? 2 : plans.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return _buildHousePlanCard(context, plans[index]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Recommended for You (Interactive Bento Section)
                Text('Recommended for You', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 14),

                Column(
                  children: [
                    // Hero Bento Card (Site Inspection)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: AppColors.shadowColor, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: Icon(Icons.architecture, size: 120, color: Colors.white.withOpacity(0.12)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.handyman, color: AppColors.onSecondaryContainer, size: 24),
                              ),
                              const SizedBox(height: 12),
                              Text('Expert Site Inspection', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('Schedule a professional site visit for your new project.', style: GoogleFonts.inter(fontSize: 13, color: AppColors.onPrimaryContainer)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BookServiceScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Book Now', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Side-by-side Interactive Bento Cards
                    Row(
                      children: [
                        // Interactive Cost Calculator Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showCostCalculatorModal(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text('Cost Calculator', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.onSecondaryContainer)),
                                      ),
                                      const Icon(Icons.calculate, color: AppColors.onSecondaryContainer, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Estimate material & labor costs instantly.',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSecondaryContainer.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Interactive Virtual Tour Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showVirtualTourModal(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text('Virtual Tour', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.onTertiaryFixed)),
                                      ),
                                      const Icon(Icons.video_library_outlined, color: AppColors.onTertiaryFixed, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Experience home plan in 3D.',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.onTertiaryFixedVariant),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyModel company) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyDetailScreen(company: company)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    company.logoUrl.isNotEmpty
                        ? company.logoUrl
                        : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.starRating, size: 16),
                          const SizedBox(width: 4),
                          Text('${company.rating} ', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                          Text('(${company.reviewCount} reviews)', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(company.location, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
                        ],
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
  }

  Widget _buildHousePlanCard(BuildContext context, HousePlanModel plan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HousePlanDetailScreen(plan: plan)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                        plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (plan.tag.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: plan.tag == 'Bestseller' ? AppColors.secondaryContainer : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan.tag.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: plan.tag == 'Bestseller' ? AppColors.onSecondaryContainer : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(plan.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          Text('${plan.bhk} • ${plan.sqft} sq.ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
