import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';

/// ============================================================================
/// FILE: user_profile_screen.dart
/// MODULE: User Module (Customer Profile UI Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Displays profile management and account settings for authenticated
///   customer users in Constructa. Renders real-time user details, user role badge,
///   quick profile action items, and session sign-out functionality.
/// ============================================================================

/// [UserProfileScreen] is a stateless widget representing the customer account profile.
///
/// Features:
/// - Real-time synchronization with current authenticated user state via [AuthService.getUserData].
/// - Displays profile avatar, user full name, email address, and active role badge.
/// - Navigation options for saved house plans, cost estimates, notification preferences, and help.
/// - Session sign-out button that purges authentication state and redirects to Login (`/login`).
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  // ---------------------------------------------------------------------------
  // BUILD METHOD & UI STRUCTURE
  // ---------------------------------------------------------------------------

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
              'User Profile',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // -------------------------------------------------------------
                // UI SECTION: User Profile Details Header Card
                // -------------------------------------------------------------
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
                            : const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName.isNotEmpty == true ? user!.fullName : 'Rahul Nair',
                              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email.isNotEmpty == true ? user!.email : 'rahul.nair@example.com',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                (user?.role ?? 'customer').toUpperCase(),
                                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // UI SECTION: Profile Settings & Preferences List
                // -------------------------------------------------------------
                _buildProfileOption(Icons.bookmark_outline, 'Saved House Plans', () {}),
                _buildProfileOption(Icons.calculate_outlined, 'Saved Cost Estimates', () {}),
                _buildProfileOption(Icons.notifications_none, 'Notification Preferences', () {}),
                _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),

                const SizedBox(height: 28),

                // -------------------------------------------------------------
                // UI SECTION: Session Sign Out Button
                // -------------------------------------------------------------
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
      },
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGET BUILDERS
  // ---------------------------------------------------------------------------

  /// Renders a styled list tile item for profile options and preferences.
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
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
        onTap: onTap,
      ),
    );
  }
}

