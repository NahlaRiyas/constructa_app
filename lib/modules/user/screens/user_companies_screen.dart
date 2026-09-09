import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/services/company_service.dart';
import 'company_detail_screen.dart';

/// UserCompaniesScreen
///
/// Directory of verified construction companies and contractors.
/// Employs MediaQuery throughout for responsive card sizing, logo scaling, and adaptive layout dimensions.
class UserCompaniesScreen extends StatefulWidget {
  const UserCompaniesScreen({super.key});

  @override
  State<UserCompaniesScreen> createState() => _UserCompaniesScreenState();
}

class _UserCompaniesScreenState extends State<UserCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Layout Sizing
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double vPadding = (h * 0.015).clamp(8.0, 16.0);
    final double appBarTitleFontSize = (w * 0.045).clamp(16.0, 22.0);
    final double sectionHeaderFontSize = (w * 0.04).clamp(14.0, 18.0);
    final double inputFontSize = (w * 0.035).clamp(12.0, 16.0);
    final double borderRadius = (w * 0.03).clamp(10.0, 16.0);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardBackground(context),
        elevation: 0,
        title: Text(
          'Companies Directory',
          style: GoogleFonts.poppins(
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText: 'Search by company name, city or specialty...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: inputFontSize * 0.95),
                prefixIcon: Icon(Icons.search, color: AppColors.getTextSecondary(context), size: (w * 0.05).clamp(18.0, 24.0)),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.getBorderLight(context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.getBorderLight(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: h * 0.018),

            Text(
              'Verified Builders & Contractors',
              style: GoogleFonts.poppins(
                fontSize: sectionHeaderFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            SizedBox(height: h * 0.012),

            Expanded(
              child: StreamBuilder<List<CompanyModel>>(
                stream: CompanyService().getCompanies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var companies = snapshot.data ?? [];
                  if (_searchQuery.isNotEmpty) {
                    companies = companies.where((c) {
                      return c.name.toLowerCase().contains(_searchQuery) ||
                          c.location.toLowerCase().contains(_searchQuery) ||
                          c.specialty.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  if (companies.isEmpty) {
                    return Center(
                      child: Text(
                        'No companies found matching search.',
                        style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: inputFontSize),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return _buildAnimatedCompanyCard(context, company, index, w, h);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renders company item cards with entrance slide and fade animation using MediaQuery dimensions.
  Widget _buildAnimatedCompanyCard(
      BuildContext context, CompanyModel company, int index, double w, double h) {
    final double logoSize = (w * 0.18).clamp(60.0, 84.0);
    final double titleFontSize = (w * 0.038).clamp(13.0, 17.0);
    final double subtitleFontSize = (w * 0.030).clamp(10.0, 13.0);
    final double borderRadius = (w * 0.04).clamp(12.0, 18.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 20),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: h * 0.016),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: AppColors.getBorderLight(context)),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyDetailScreen(company: company),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(w * 0.035),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(w * 0.03),
                          child: Image.network(
                            company.logoUrl.isNotEmpty
                                ? company.logoUrl
                                : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: w * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              SizedBox(height: h * 0.003),
                              Text(
                                company.specialty,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                              SizedBox(height: h * 0.006),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: (w * 0.036).clamp(12.0, 16.0), color: AppColors.getTextSecondary(context)),
                                  SizedBox(width: w * 0.01),
                                  Expanded(
                                    child: Text(
                                      company.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: subtitleFontSize,
                                        color: AppColors.getTextSecondary(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: h * 0.006),
                              Row(
                                children: [
                                  Icon(Icons.star, color: AppColors.starRating, size: (w * 0.04).clamp(14.0, 18.0)),
                                  SizedBox(width: w * 0.008),
                                  Text(
                                    '${company.rating} ',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: titleFontSize * 0.88,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                  Text(
                                    '(${company.reviewCount} reviews)',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextSecondary(context),
                                      fontSize: subtitleFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.primary, size: (w * 0.06).clamp(20.0, 26.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
