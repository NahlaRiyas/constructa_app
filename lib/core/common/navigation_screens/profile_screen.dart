import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../utils/global.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery metrics
    initScreenSize(context);

    final double horizontalPadding = w * 0.05;
    final double avatarRadius = w * 0.1;

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
              'User Profile',
              style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: height * 0.02),
            child: Column(
              children: [
                // Header Profile Info Card
                Container(
                  padding: EdgeInsets.all(w * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: AppColors.surfaceLight,
                        backgroundImage: (user?.profileImageUrl != null && user!.profileImageUrl.isNotEmpty)
                            ? NetworkImage(user.profileImageUrl)
                            : const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS'),
                      ),
                      SizedBox(width: w * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'User Name',
                              style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: height * 0.0025),
                            Text(
                              user?.email ?? 'email@example.com',
                              style: GoogleFonts.poppins(fontSize: w * 0.03, color: AppColors.textSecondary),
                            ),
                            SizedBox(height: height * 0.0075),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: height * 0.004),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user?.role.toUpperCase() ?? 'VERIFIED CLIENT',
                                style: GoogleFonts.poppins(fontSize: w * 0.025, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.025),

            // Settings Options List
            _buildProfileOption(Icons.bookmark_outline, 'Saved House Plans'),
            _buildProfileOption(Icons.calculate_outlined, 'Saved Cost Estimates'),
            _buildProfileOption(Icons.notifications_none, 'Notification Preferences'),
            _buildProfileOption(Icons.help_outline, 'Help & Support'),

            SizedBox(height: height * 0.03),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
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
                label: Text('Log Out', style: GoogleFonts.poppins(fontSize: w * 0.035, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.0125),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary, size: w * 0.055),
          title: Text(title, style: GoogleFonts.poppins(fontSize: w * 0.032, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: w * 0.05),
          onTap: () {},
        ),
      ),
    );
  }
}
