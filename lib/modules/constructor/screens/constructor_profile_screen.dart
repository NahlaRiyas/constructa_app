import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import 'company_profile_screen.dart';
import 'manage_projects_screen.dart';
import 'constructor_reviews_screen.dart';

class ConstructorProfileScreen extends StatelessWidget {
  const ConstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            title: Text(
              'Constructor Company Profile',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowColor, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.surfaceLight,
                        backgroundImage: (user?.profileImageUrl != null && user!.profileImageUrl.isNotEmpty)
                            ? NetworkImage(user.profileImageUrl)
                            : const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName.isNotEmpty == true ? user!.fullName : 'BuildWell Constructions',
                              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email.isNotEmpty == true ? user!.email : 'contact@buildwell.com',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'REGISTERED CONTRACTOR',
                                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Management Options List
                _buildProfileOption(
                  Icons.edit_note,
                  'Edit Company Business Profile',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompanyProfileScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  Icons.business,
                  'Manage Completed Projects',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageProjectsScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  Icons.star_outline,
                  'Customer Reviews & Feedback',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConstructorReviewsScreen()),
                    );
                  },
                ),
                _buildProfileOption(Icons.notifications_none, 'Notification Settings', () {}),
                _buildProfileOption(Icons.help_outline, 'Contractor Support & Guidelines', () {}),

                const SizedBox(height: 28),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await AuthService().signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusDanger,
                      side: const BorderSide(color: AppColors.statusDanger),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text('Log Out Company Account', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondary, size: 22),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        onTap: onTap,
      ),
    );
  }
}
