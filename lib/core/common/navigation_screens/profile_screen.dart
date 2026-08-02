import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../services/auth_service.dart';
import '../utils/global.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery metrics
    initScreenSize(context);

    final double horizontalPadding = w > 400 ? 20.0 : 14.0;
    final double avatarRadius = w > 360 ? 42.0 : 34.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(fontSize: w > 360 ? 18 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Column(
          children: [
            // Header Profile Info Card
            Container(
              padding: EdgeInsets.all(w > 360 ? 20 : 14),
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
                    backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rahul Nair',
                          style: GoogleFonts.poppins(fontSize: w > 360 ? 18 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'rahul.design@constructa.io',
                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Verified Client',
                            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                label: Text('Log Out', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        onTap: () {},
      ),
    );
  }
}
