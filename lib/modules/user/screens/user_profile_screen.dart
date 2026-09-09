import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/common/utils/global.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/common/utils/app_settings.dart';
import 'edit_user_profile_screen.dart';
import 'user_bookings_screen.dart';
import 'house_plans_screen.dart';
import 'user_companies_screen.dart';

/// ============================================================================
/// FILE: user_profile_screen.dart
/// MODULE: User Module (Customer Profile UI Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Displays profile management, quick stats, account settings, notification
///   preferences, support options, and session sign-out functionality for
///   authenticated customer users using MediaQuery for responsive layout sizing.
/// ============================================================================

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Selected Theme Mode State
  late String _selectedTheme;

  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _selectedTheme = AppSettings().themeName;
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD & MAIN UI STRUCTURE
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = isDark ? AppColors.textMuted : AppColors.textSecondary;
    final borderColor = theme.colorScheme.outlineVariant;

    // MediaQuery Responsive Sizing
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final double hPadding = screenWidth * 0.04; // 4% screen width
    final double vPadding = screenHeight * 0.02; // 2% screen height
    final double sectionGap = screenHeight * 0.025; // 2.5% screen height
    final double buttonHeight = screenHeight * 0.06; // 6% screen height

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: cardBg,
            elevation: 0,
            title: Text(
              'User Profile',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------------
                // UI SECTION 1: User Profile Details Header Card
                // -------------------------------------------------------------
                _buildProfileHeaderCard(context, user, cardBg, textColor, subTextColor, borderColor, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.018),

                // -------------------------------------------------------------
                // UI SECTION 2: Profile Completeness Progress Banner
                // -------------------------------------------------------------
                _buildProfileCompletenessBanner(user, cardBg, textColor, borderColor, screenWidth, screenHeight),
                SizedBox(height: sectionGap),

                // -------------------------------------------------------------
                // UI SECTION 3: Quick Action / Statistics Overview Cards
                // -------------------------------------------------------------
                _buildQuickStatsOverview(context, user, cardBg, textColor, subTextColor, borderColor, screenWidth, screenHeight),
                SizedBox(height: sectionGap),

                // -------------------------------------------------------------
                // UI SECTION 4: Account & Service Options
                // -------------------------------------------------------------
                _buildSectionHeader('Account & Services', screenWidth),
                SizedBox(height: screenHeight * 0.01),

                _buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update name, phone, and profile picture',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfileScreen(user: user),
                        ),
                      );
                    } else {
                      _showSnackBar('Profile data loading, please try again.');
                    }
                  },
                ),

                _buildProfileOption(
                  icon: Icons.calendar_today_outlined,
                  title: 'My Bookings & Inquiries',
                  subtitle: 'View and track booked construction services',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserBookingsScreen(),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.architecture_outlined,
                  title: 'Explore House Plans',
                  subtitle: 'Browse 2D/3D floor plans and cost estimates',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HousePlansScreen(),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.business_outlined,
                  title: 'Construction Companies',
                  subtitle: 'Find verified contractors and builders',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserCompaniesScreen(),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.lock_reset_outlined,
                  title: 'Change Password',
                  subtitle: 'Send password reset link to your email',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () => _handlePasswordReset(user),
                ),

                SizedBox(height: sectionGap),

                // -------------------------------------------------------------
                // UI SECTION 5: Preferences & Settings
                // -------------------------------------------------------------
                _buildSectionHeader('Preferences & Settings', screenWidth),
                SizedBox(height: screenHeight * 0.01),

                _buildProfileOption(
                  icon: Icons.palette_outlined,
                  title: 'App Theme',
                  subtitle: 'Current: $_selectedTheme',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: _showThemeSelectionDialog,
                ),

                SizedBox(height: sectionGap),

                // -------------------------------------------------------------
                // UI SECTION 6: Support & Information
                // -------------------------------------------------------------
                _buildSectionHeader('Support & Legal', screenWidth),
                SizedBox(height: screenHeight * 0.01),

                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'Help & Support Center',
                  subtitle: 'FAQs, contact support, or report an issue',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: _showHelpSupportDialog,
                ),

                _buildProfileOption(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Terms & Privacy Policy',
                  subtitle: 'Read terms of service and privacy guarantees',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: _showPrivacyPolicyDialog,
                ),

                _buildProfileOption(
                  icon: Icons.info_outline,
                  title: 'About Constructa App',
                  subtitle: 'App version 1.0.0 (College Project Build)',
                  cardBg: cardBg,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: _showAboutDialog,
                ),

                SizedBox(height: sectionGap * 1.2),

                // -------------------------------------------------------------
                // UI SECTION 7: Session Sign-Out Button
                // -------------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmSignOut(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusDanger,
                      side: const BorderSide(color: AppColors.statusDanger),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    icon: Icon(Icons.logout, size: screenWidth * 0.045),
                    label: Text(
                      'Log Out',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.036,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENT BUILDERS (WITH MEDIAQUERY RESPONSIVE DIMENSIONS)
  // ---------------------------------------------------------------------------

  /// Renders user profile summary card using MediaQuery calculated dimensions.
  Widget _buildProfileHeaderCard(
    BuildContext context,
    UserModel? user,
    Color cardBg,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    double screenWidth,
    double screenHeight,
  ) {
    final String fullName = (user?.fullName.isNotEmpty == true) ? user!.fullName : 'Rahul Nair';
    final String email = (user?.email.isNotEmpty == true) ? user!.email : 'rahul.nair@example.com';
    final String phone = (user?.phoneNumber.isNotEmpty == true) ? user!.phoneNumber : 'Add phone number';
    final String role = (user?.role.isNotEmpty == true) ? user!.role : 'customer';

    final avatarRadius = screenWidth * 0.09; // ~36dp on standard mobile screens

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: AppColors.surfaceLight,
                    backgroundImage: (user?.profileImageUrl != null && user!.profileImageUrl.isNotEmpty)
                        ? NetworkImage(user.profileImageUrl) as ImageProvider
                        : null,
                    child: (user?.profileImageUrl == null || user!.profileImageUrl.isEmpty)
                        ? Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                            style: GoogleFonts.poppins(
                              fontSize: avatarRadius * 0.75,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserProfileScreen(user: user),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.012),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.edit, size: screenWidth * 0.032, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.03,
                        color: subTextColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: screenWidth * 0.032, color: subTextColor),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          phone,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.028,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025, vertical: screenHeight * 0.004),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.026,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Renders profile completeness progress bar using MediaQuery sizing.
  Widget _buildProfileCompletenessBanner(
    UserModel? user,
    Color cardBg,
    Color textColor,
    Color borderColor,
    double screenWidth,
    double screenHeight,
  ) {
    int score = 0;
    if (user != null) {
      if (user.fullName.isNotEmpty) score += 25;
      if (user.email.isNotEmpty) score += 25;
      if (user.phoneNumber.isNotEmpty) score += 25;
      if (user.profileImageUrl.isNotEmpty) score += 25;
    } else {
      score = 50;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035, vertical: screenHeight * 0.014),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                '$score%',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.008),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: AppColors.borderLight.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  /// Renders quick statistics overview cards streaming active leads & plans.
  Widget _buildQuickStatsOverview(
    BuildContext context,
    UserModel? user,
    Color cardBg,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    double screenWidth,
    double screenHeight,
  ) {
    return Row(
      children: [
        // Card 1: My Bookings Counter
        Expanded(
          child: StreamBuilder<List<BookingModel>>(
            stream: _bookingService.getUserBookings(user?.uid ?? ''),
            builder: (context, snapshot) {
              final bookingCount = snapshot.hasData ? snapshot.data!.length : 0;
              return _buildStatCard(
                icon: Icons.calendar_month,
                value: '$bookingCount',
                label: 'Bookings',
                cardBg: cardBg,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserBookingsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(width: screenWidth * 0.025),

        // Card 2: House Plans Shortcut
        Expanded(
          child: _buildStatCard(
            icon: Icons.architecture,
            value: '2D / 3D',
            label: 'House Plans',
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            borderColor: borderColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HousePlansScreen(),
                ),
              );
            },
          ),
        ),
        SizedBox(width: screenWidth * 0.025),

        // Card 3: Contractors Shortcut
        Expanded(
          child: _buildStatCard(
            icon: Icons.business,
            value: 'Verified',
            label: 'Contractors',
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            borderColor: borderColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserCompaniesScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Helper builder for individual statistics overview cards with MediaQuery sizing.
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    required Color borderColor,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(screenWidth * 0.035),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.016, horizontal: screenWidth * 0.025),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: screenWidth * 0.055),
            SizedBox(height: screenHeight * 0.008),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.026,
                color: subTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Renders section header text scaled with MediaQuery.
  Widget _buildSectionHeader(String title, double screenWidth) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.036,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: 0.3,
      ),
    );
  }

  /// Renders custom styled option tile with MediaQuery responsive dimensions.
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    required Color borderColor,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.002),
        leading: Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
          ),
          child: Icon(icon, color: AppColors.primary, size: screenWidth * 0.05),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.032,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.027,
                  color: subTextColor,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: subTextColor,
          size: screenWidth * 0.05,
        ),
        onTap: onTap,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTERACTIVE FEATURE HANDLERS & MODALS
  // ---------------------------------------------------------------------------

  /// Displays Change Password dialog.
  Future<void> _handlePasswordReset(UserModel? user) async {
    final email = user?.email ?? '';
    if (email.isEmpty) {
      _showSnackBar('No valid email found to reset password.');
      return;
    }

    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.lock_reset, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Change Password',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update password for $email',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      if (errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.statusDanger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.statusDanger.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            errorMessage!,
                            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.statusDanger),
                          ),
                        ),
                      ],

                      // Current Password Field
                      Text('Current Password', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: obscureCurrent,
                        style: GoogleFonts.poppins(fontSize: 13),
                        validator: (val) => (val == null || val.isEmpty) ? 'Enter current password' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () => setModalState(() => obscureCurrent = !obscureCurrent),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // New Password Field
                      Text('New Password', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: obscureNew,
                        style: GoogleFonts.poppins(fontSize: 13),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter new password';
                          if (val.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key, size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () => setModalState(() => obscureNew = !obscureNew),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Confirm New Password Field
                      Text('Confirm New Password', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirm,
                        style: GoogleFonts.poppins(fontSize: 13),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Confirm your new password';
                          if (val != newPasswordController.text) return 'Passwords do not match';
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.check_circle_outline, size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () => setModalState(() => obscureConfirm = !obscureConfirm),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Reset via Email Fallback Option
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : () async {
                            Navigator.pop(context);
                            try {
                              await AuthService().resetPassword(email);
                              _showSnackBar('Password reset link sent to $email');
                            } catch (e) {
                              _showSnackBar('Failed to send reset link: ${e.toString()}');
                            }
                          },
                          child: Text(
                            'Forgot current password?',
                            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    if (!formKey.currentState!.validate()) return;

                    setModalState(() {
                      isLoading = true;
                      errorMessage = null;
                    });

                    try {
                      await AuthService().changePassword(
                        currentPassword: currentPasswordController.text.trim(),
                        newPassword: newPasswordController.text.trim(),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        _showSnackBar('Password updated successfully!');
                      }
                    } catch (e) {
                      setModalState(() {
                        isLoading = false;
                        String msg = e.toString();
                        if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
                          errorMessage = 'Current password is incorrect. Please check and try again.';
                        } else if (msg.contains('weak-password')) {
                          errorMessage = 'The new password is too weak.';
                        } else {
                          errorMessage = 'Failed to change password: ${e.toString()}';
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Update Password', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }



  /// Displays Theme selection dialog.
  void _showThemeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final options = ['System Default', 'Light Theme', 'Dark Theme'];
        return AlertDialog(
          title: Text(
            'Select App Theme',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = AppSettings().themeName == option;
              return ListTile(
                title: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                    : Icon(Icons.circle_outlined, color: AppColors.borderLight, size: 20),
                onTap: () {
                  AppSettings().setTheme(option);
                  setState(() => _selectedTheme = option);
                  Navigator.pop(context);
                  _showSnackBar('Theme updated to $option');
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Displays Help & Support dialog with contacts, FAQs, and issue report trigger.
  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Help & Support Center',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Constructa Support',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('support@constructa.app', style: GoogleFonts.poppins(fontSize: w*0.03)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('+91 98765 43210', style: GoogleFonts.poppins(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Frequently Asked Questions',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: Text('How do I book a construction service?', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Navigate to Companies or House Plans screen, choose your desired contractor or design, and click "Book Service". Fill required project details and submit.',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('How do I track or cancel my booking?', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Open "My Bookings" from your profile or navigation shell to inspect current status (Pending / Confirmed / Cancelled). You can cancel pending bookings directly.',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Are construction companies verified?', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Yes, all listed constructors in Constructa undergo admin license and verification check before listing house plans and services.',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showReportIssueDialog();
                  },
                  icon: const Icon(Icons.report_problem_outlined, size: 16),
                  label: Text('Report an Issue', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  /// Displays a feedback / issue reporting form dialog.
  void _showReportIssueDialog() {
    final issueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report an Issue', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: issueController,
          maxLines: 4,
          style: GoogleFonts.poppins(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Describe the issue or bug you experienced...',
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (issueController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _showSnackBar('Thank you! Your feedback has been submitted to support.');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Submit', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Displays Terms & Privacy Policy dialog.
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Privacy Policy', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(
          child: Text(
            '1. Privacy Protection:\nConstructa respects user privacy and encrypts profile credentials in accordance with Firebase Security Guidelines.\n\n'
            '2. Booking Commitments:\nService bookings created on Constructa represent preliminary project inquiries between customers and verified constructors.\n\n'
            '3. Data Rights:\nUsers retain full ownership of profile data and can update or purge records via account settings at any time.',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('I Understand', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Displays About Constructa App modal dialog.
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Constructa', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.construction, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Constructa App v1.0.0',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Digital Construction & Architecture Platform',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
            const Divider(height: 24),
            Text(
              'College Project Build for modern home building solutions, 2D/3D house planning, and contractor management.',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  /// Displays confirmation dialog before signing out user session.
  Future<void> _confirmSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to log out of your Constructa account?',
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusDanger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService().signOut();
      if (mounted && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  /// Helper utility to display feedback snackbars.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 12)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
