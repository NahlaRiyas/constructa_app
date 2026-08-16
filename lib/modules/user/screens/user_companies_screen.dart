import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/services/company_service.dart';
import '../../../core/common/utils/global.dart';
import 'company_detail_screen.dart';

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
    initScreenSize(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'Companies Directory',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by company name, city or specialty...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Verified Builders & Contractors',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

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
                      child: Text('No companies found matching search.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    );
                  }

                  return ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return _buildCompanyCard(context, company);
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

  Widget _buildCompanyCard(BuildContext context, CompanyModel company) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4)),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    company.logoUrl.isNotEmpty ? company.logoUrl : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
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
                      Text(company.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(company.specialty, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(company.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.starRating, size: 16),
                          const SizedBox(width: 2),
                          Text('${company.rating} ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                          Text('(${company.reviewCount} reviews)', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
