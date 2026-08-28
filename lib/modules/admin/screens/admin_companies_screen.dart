import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/services/admin_service.dart';

class AdminCompaniesScreen extends StatelessWidget {
  const AdminCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage Companies', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Verify, review, and manage construction companies', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            StreamBuilder<List<CompanyModel>>(
              stream: AdminService().getAllCompanies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error loading companies: ${snapshot.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                    ),
                  );
                }
                final companies = snapshot.data ?? [];
                if (companies.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text('No companies found.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 850,
                    child: _buildCompaniesTable(context, companies),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompaniesTable(BuildContext context, List<CompanyModel> companies) {
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
                Expanded(flex: 2, child: Text('Company', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Specialty', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Location', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Rating', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Status', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 160),
              ],
            ),
          ),
          ...companies.map((company) => _buildCompanyRow(context, company)),
        ],
      ),
    );
  }

  Widget _buildCompanyRow(BuildContext context, CompanyModel company) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.surfaceLight,
                  backgroundImage: company.logoUrl.isNotEmpty ? NetworkImage(company.logoUrl) : null,
                  child: company.logoUrl.isEmpty ? const Icon(Icons.business, size: 18, color: AppColors.textMuted) : null,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text(company.email, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Text(company.specialty, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          Expanded(child: Text(company.location, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.star, size: 14, color: AppColors.starRating),
                const SizedBox(width: 4),
                Text('${company.rating}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(' (${company.reviewCount})', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (company.isVerified ? AppColors.statusSuccess : AppColors.statusPending).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                company.isVerified ? 'VERIFIED' : 'PENDING',
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: company.isVerified ? AppColors.statusSuccess : AppColors.statusPending),
              ),
            ),
          ),
          SizedBox(
            width: 160,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    company.isVerified ? Icons.verified_outlined : Icons.verified,
                    size: 18,
                    color: company.isVerified ? AppColors.statusPending : AppColors.statusSuccess,
                  ),
                  onPressed: () async {
                    await AdminService().verifyCompany(company.id, !company.isVerified);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(company.isVerified ? 'Verification removed.' : 'Company verified!')),
                      );
                    }
                  },
                  tooltip: company.isVerified ? 'Remove Verification' : 'Verify Company',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusDanger),
                  onPressed: () => _confirmDelete(context, company),
                  tooltip: 'Delete Company',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CompanyModel company) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Company', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${company.name}"? This action cannot be undone.', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              await AdminService().deleteCompany(company.id);
              if (context.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company "${company.name}" deleted.')));
              }
            },
            child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.statusDanger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
