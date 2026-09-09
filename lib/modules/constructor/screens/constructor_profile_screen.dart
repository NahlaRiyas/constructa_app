import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/company_service.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/services/media_upload_service.dart';
import '../../../core/services/project_service.dart';
import '../../../core/common/utils/app_settings.dart';
import 'company_profile_screen.dart';
import 'manage_bookings_screen.dart';
import 'manage_house_plans_screen.dart';
import 'manage_projects_screen.dart';
import 'constructor_reviews_screen.dart';

/// ============================================================================
/// FILE: constructor_profile_screen.dart
/// MODULE: Constructor Module (Company Profile UI Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Displays contractor profile management, quick stats, account settings,
///   notification preferences, app theme options, password security, support,
///   and session sign-out using MediaQuery for responsive layout sizing.
/// ============================================================================

class ConstructorProfileScreen extends StatefulWidget {
  const ConstructorProfileScreen({super.key});

  @override
  State<ConstructorProfileScreen> createState() => _ConstructorProfileScreenState();
}

class _ConstructorProfileScreenState extends State<ConstructorProfileScreen> {
  // Notification Preferences State
  bool _notifyBookings = true;
  bool _notifyReviews = true;
  bool _notifySystem = true;
  bool _soundEnabled = true;

  // Selected Theme Mode State
  late String _selectedTheme;

  bool _isUploadingPhoto = false;

  final BookingService _bookingService = BookingService();
  final HousePlanService _housePlanService = HousePlanService();
  final ProjectService _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    _selectedTheme = AppSettings().themeName;
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD & MAIN UI STRUCTURE (WITH MEDIAQUERY)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // MediaQuery Responsive Layout Calculations
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final double hPadding = screenWidth * 0.04;
    final double vPadding = screenHeight * 0.02;
    final double sectionGap = screenHeight * 0.025;
    final double buttonHeight = screenHeight * 0.06;

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;

        return StreamBuilder<CompanyModel?>(
          stream: CompanyService().getCompanyStream(uid),
          builder: (context, companySnapshot) {
            final company = companySnapshot.data;

            final String avatarUrl = (company?.logoUrl.isNotEmpty == true)
                ? company!.logoUrl
                : (user?.profileImageUrl.isNotEmpty == true ? user!.profileImageUrl : '');

            final String displayName = (company?.name.isNotEmpty == true)
                ? company!.name
                : (user?.fullName.isNotEmpty == true ? user!.fullName : 'BuildWell Constructions');

            final String displayEmail = (company?.email.isNotEmpty == true)
                ? company!.email
                : (user?.email.isNotEmpty == true ? user!.email : (FirebaseAuth.instance.currentUser?.email ?? 'contact@buildwell.com'));

            final String displayPhone = (company?.phone.isNotEmpty == true)
                ? company!.phone
                : (user?.phoneNumber.isNotEmpty == true ? user!.phoneNumber : 'Add contact phone');

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.cardBackground,
                elevation: 0,
                title: Text(
                  'Constructor Profile',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------------
                    // UI SECTION 1: Company Profile Header Card
                    // ---------------------------------------------------------
                    _buildProfileHeaderCard(
                        context, uid, displayName, displayEmail, displayPhone, avatarUrl, screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.018),

                    // ---------------------------------------------------------
                    // UI SECTION 2: Profile Completeness Progress Banner
                    // ---------------------------------------------------------
                    _buildProfileCompletenessBanner(company, user, screenWidth, screenHeight),
                    SizedBox(height: sectionGap),

                    // ---------------------------------------------------------
                    // UI SECTION 3: Quick Action / Statistics Overview Cards
                    // ---------------------------------------------------------
                    _buildQuickStatsOverview(context, uid, screenWidth, screenHeight),
                    SizedBox(height: sectionGap),

                    // ---------------------------------------------------------
                    // UI SECTION 4: Business Management & Services
                    // ---------------------------------------------------------
                    _buildSectionHeader('Business Management', screenWidth),
                    SizedBox(height: screenHeight * 0.01),

                    _buildProfileOption(
                      icon: Icons.edit_note,
                      title: 'Edit Company Profile',
                      subtitle: 'Update address, description, logo & contacts',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompanyProfileScreen()),
                        );
                      },
                    ),

                    _buildProfileOption(
                      icon: Icons.assignment_outlined,
                      title: 'Customer Bookings Console',
                      subtitle: 'Manage client leads and booking statuses',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageBookingsScreen()),
                        );
                      },
                    ),

                    _buildProfileOption(
                      icon: Icons.architecture_outlined,
                      title: 'Manage House Plans',
                      subtitle: 'Publish and edit 2D/3D blueprints & prices',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageHousePlansScreen()),
                        );
                      },
                    ),

                    _buildProfileOption(
                      icon: Icons.business_outlined,
                      title: 'Showcase Completed Projects',
                      subtitle: 'Upload site photos & finished construction works',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageProjectsScreen()),
                        );
                      },
                    ),

                    _buildProfileOption(
                      icon: Icons.star_outline,
                      title: 'Customer Reviews & Feedback',
                      subtitle: 'View star ratings and reply to user reviews',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConstructorReviewsScreen()),
                        );
                      },
                    ),

                    _buildProfileOption(
                      icon: Icons.lock_reset_outlined,
                      title: 'Change Password',
                      subtitle: 'Update company account password securely',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () => _handlePasswordReset(displayEmail),
                    ),

                    SizedBox(height: sectionGap),

                    // ---------------------------------------------------------
                    // UI SECTION 5: Preferences & App Settings
                    // ---------------------------------------------------------
                    _buildSectionHeader('Preferences & Settings', screenWidth),
                    SizedBox(height: screenHeight * 0.01),

                    // _buildProfileOption(
                    //   icon: Icons.notifications_none_outlined,
                    //   title: 'Notification Preferences',
                    //   subtitle: 'Configure alerts for new lead bookings & reviews',
                    //   screenWidth: screenWidth,
                    //   screenHeight: screenHeight,
                    //   onTap: () => _showNotificationSettings(context),
                    // ),

                    _buildProfileOption(
                      icon: Icons.palette_outlined,
                      title: 'App Theme',
                      subtitle: 'Current: $_selectedTheme',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: _showThemeSelectionDialog,
                    ),

                    SizedBox(height: sectionGap),

                    // ---------------------------------------------------------
                    // UI SECTION 6: Support & Information
                    // ---------------------------------------------------------
                    _buildSectionHeader('Support & Legal', screenWidth),
                    SizedBox(height: screenHeight * 0.01),

                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: 'Contractor Support & Guidelines',
                      subtitle: 'Contact platform support or report an issue',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: () => _showSupportDialog(context),
                    ),

                    _buildProfileOption(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Terms & Constructor Policy',
                      subtitle: 'Read terms of service and compliance rules',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: _showPrivacyPolicyDialog,
                    ),

                    _buildProfileOption(
                      icon: Icons.info_outline,
                      title: 'About Constructa App',
                      subtitle: 'App version 1.0.0 (College Project Build)',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onTap: _showAboutDialog,
                    ),

                    SizedBox(height: sectionGap * 1.2),

                    // ---------------------------------------------------------
                    // UI SECTION 7: Session Sign-Out Button
                    // ---------------------------------------------------------
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
                          'Log Out Company Account',
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
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENT BUILDERS (WITH MEDIAQUERY RESPONSIVE DIMENSIONS)
  // ---------------------------------------------------------------------------

  /// Renders company summary header card containing logo, name, email, phone, role, & edit shortcut.
  Widget _buildProfileHeaderCard(
    BuildContext context,
    String uid,
    String displayName,
    String displayEmail,
    String displayPhone,
    String avatarUrl,
    double screenWidth,
    double screenHeight,
  ) {
    final avatarRadius = screenWidth * 0.09;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
          GestureDetector(
            onTap: _isUploadingPhoto ? null : () => _showPhotoOptions(context, uid),
            child: Stack(
              children: [
                Container(
                  width: avatarRadius * 2,
                  height: avatarRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceLight,
                    border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3), width: 2),
                  ),
                  child: ClipOval(
                    child: _isUploadingPhoto
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.secondary),
                            ),
                          )
                        : (avatarUrl.isNotEmpty
                            ? Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                    Icons.business_rounded,
                                    size: avatarRadius,
                                    color: AppColors.secondary),
                              )
                            : Icon(Icons.business_rounded,
                                size: avatarRadius, color: AppColors.secondary)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.012),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: screenWidth * 0.032),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  displayEmail,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Row(
                  children: [
                    Icon(Icons.phone_outlined, size: screenWidth * 0.032, color: AppColors.textSecondary),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      displayPhone,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.028,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.008),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025, vertical: screenHeight * 0.004),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  ),
                  child: Text(
                    'REGISTERED CONTRACTOR',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.025,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Renders profile completeness progress bar using MediaQuery dimensions.
  Widget _buildProfileCompletenessBanner(
    CompanyModel? company,
    UserModel? user,
    double screenWidth,
    double screenHeight,
  ) {
    int score = 0;
    if (company != null) {
      if (company.name.isNotEmpty) score += 20;
      if (company.email.isNotEmpty) score += 20;
      if (company.phone.isNotEmpty) score += 20;
      if (company.logoUrl.isNotEmpty) score += 20;
      if (company.description.isNotEmpty || company.location.isNotEmpty) score += 20;
    } else {
      score = 40;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035, vertical: screenHeight * 0.014),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Company Profile Completion',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$score%',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
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
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  /// Renders quick statistics overview cards streaming active leads, plans, & projects.
  Widget _buildQuickStatsOverview(
    BuildContext context,
    String uid,
    double screenWidth,
    double screenHeight,
  ) {
    return Row(
      children: [
        // Card 1: Active Leads Counter
        Expanded(
          child: StreamBuilder<List<BookingModel>>(
            stream: _bookingService.getCompanyBookings(uid),
            builder: (context, snapshot) {
              final activeCount = snapshot.hasData
                  ? snapshot.data!
                      .where((b) => b.status != 'Cancelled' && b.status != 'Completed')
                      .length
                  : 0;
              return _buildStatCard(
                icon: Icons.assignment_turned_in,
                value: '$activeCount',
                label: 'Active Leads',
                color: AppColors.secondary,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageBookingsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(width: screenWidth * 0.025),

        // Card 2: House Plans Counter
        Expanded(
          child: StreamBuilder<List<HousePlanModel>>(
            stream: _housePlanService.getCompanyHousePlans(uid),
            builder: (context, snapshot) {
              final planCount = snapshot.hasData ? snapshot.data!.length : 0;
              return _buildStatCard(
                icon: Icons.architecture,
                value: '$planCount',
                label: 'House Plans',
                color: AppColors.primary,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageHousePlansScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(width: screenWidth * 0.025),

        // Card 3: Showcase Projects Counter
        Expanded(
          child: StreamBuilder<List<ProjectModel>>(
            stream: _projectService.getProjects(companyId: uid),
            builder: (context, snapshot) {
              final projectCount = snapshot.hasData ? snapshot.data!.length : 0;
              return _buildStatCard(
                icon: Icons.business,
                value: '$projectCount',
                label: 'Projects',
                color: AppColors.statusSuccess,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageProjectsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Helper builder for individual statistics overview cards using MediaQuery dimensions.
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(color: AppColors.borderLight),
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
            Icon(icon, color: color, size: screenWidth * 0.055),
            SizedBox(height: screenHeight * 0.008),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.026,
                color: AppColors.textSecondary,
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
        color: AppColors.secondary,
        letterSpacing: 0.3,
      ),
    );
  }

  /// Renders custom styled option tile with MediaQuery responsive dimensions.
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.002),
        leading: Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
          ),
          child: Icon(icon, color: AppColors.secondary, size: screenWidth * 0.05),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.032,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.027,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: screenWidth * 0.05,
        ),
        onTap: onTap,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTERACTIVE FEATURE HANDLERS & MODALS
  // ---------------------------------------------------------------------------

  /// Displays photo upload options (camera vs gallery).
  void _showPhotoOptions(BuildContext context, String uid) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Company Logo / Photo',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.secondary),
                title: Text('Choose From Gallery',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.gallery, uid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: Text('Take New Photo',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.camera, uid);
                },
              ),
              ListTile(
                leading: Icon(Icons.business_outlined, color: AppColors.textSecondary),
                title: Text('Edit Full Company Profile',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CompanyProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles photo selection and image upload via [MediaUploadService].
  Future<void> _pickAndUploadPhoto(ImageSource source, String uid) async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: source);
      if (file == null) return;

      setState(() => _isUploadingPhoto = true);

      // Upload to ImgBB with automatic <= 3MB compression
      final url = await MediaUploadService().uploadImage(file);

      // Update Company Profile
      final comp = await CompanyService().getCompanyById(uid) ??
          CompanyModel(
            id: uid,
            uid: uid,
            name: FirebaseAuth.instance.currentUser?.displayName ?? '',
            specialty: '',
            location: '',
            description: '',
            phone: '',
            email: FirebaseAuth.instance.currentUser?.email ?? '',
            logoUrl: url,
          );

      final updatedComp = CompanyModel(
        id: comp.id,
        uid: comp.uid,
        name: comp.name,
        specialty: comp.specialty,
        location: comp.location,
        description: comp.description,
        phone: comp.phone,
        email: comp.email,
        logoUrl: url,
      );

      await CompanyService().saveCompanyProfile(updatedComp);

      // Update Firebase Auth photo URL
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);

      if (mounted) {
        _showSnackBar('Company logo updated successfully!');
      }
    } catch (e) {
      debugPrint('Error uploading profile photo: $e');
      if (mounted) {
        _showSnackBar('Failed to upload photo: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  /// Displays Change Password dialog.
  Future<void> _handlePasswordReset(String email) async {
    if (email.isEmpty) {
      _showSnackBar('No valid account email found to reset password.');
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
                  const Icon(Icons.lock_reset, color: AppColors.secondary),
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
                        'Update password for company account:\n$email',
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
                            border: Border.all(
                                color: AppColors.statusDanger.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            errorMessage!,
                            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.statusDanger),
                          ),
                        ),
                      ],

                      // Current Password Field
                      Text('Current Password',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: obscureCurrent,
                        style: GoogleFonts.poppins(fontSize: 13),
                        validator: (val) =>
                            (val == null || val.isEmpty) ? 'Enter current password' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline,
                              size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                                obscureCurrent ? Icons.visibility_off : Icons.visibility,
                                size: 18),
                            onPressed: () =>
                                setModalState(() => obscureCurrent = !obscureCurrent),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // New Password Field
                      Text('New Password',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
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
                          prefixIcon:
                              Icon(Icons.key, size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                                obscureNew ? Icons.visibility_off : Icons.visibility,
                                size: 18),
                            onPressed: () => setModalState(() => obscureNew = !obscureNew),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Confirm New Password Field
                      Text('Confirm New Password',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
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
                          prefixIcon: Icon(Icons.check_circle_outline,
                              size: 18, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                                obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                size: 18),
                            onPressed: () =>
                                setModalState(() => obscureConfirm = !obscureConfirm),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Reset via Email Fallback Option
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () async {
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
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600),
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
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
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
                              if (msg.contains('wrong-password') ||
                                  msg.contains('invalid-credential')) {
                                errorMessage =
                                    'Current password is incorrect. Please check and try again.';
                              } else if (msg.contains('weak-password')) {
                                errorMessage = 'The new password is too weak.';
                              } else {
                                errorMessage = 'Failed to change password: ${e.toString()}';
                              }
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Update Password',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Displays Contractor Notification Preferences Bottom Sheet.
  // void _showNotificationSettings(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: AppColors.cardBackground,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (ctx) {
  //       return StatefulBuilder(
  //         builder: (context, setSheetState) {
  //           return Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Center(
  //                   child: Container(
  //                     width: 40,
  //                     height: 4,
  //                     decoration: BoxDecoration(
  //                       color: AppColors.borderLight,
  //                       borderRadius: BorderRadius.circular(2),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Text(
  //                   'Contractor Notification Settings',
  //                   style: GoogleFonts.poppins(
  //                       fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   'Manage instant alerts for your construction business',
  //                   style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 SwitchListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   activeTrackColor: AppColors.secondary,
  //                   title: Text('Booking Requests',
  //                       style: GoogleFonts.poppins(
  //                           fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
  //                   subtitle: Text('Receive immediate alerts when clients book consultations',
  //                       style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
  //                   value: _notifyBookings,
  //                   onChanged: (val) {
  //                     setSheetState(() => _notifyBookings = val);
  //                     setState(() => _notifyBookings = val);
  //                   },
  //                 ),
  //                 const Divider(height: 1),
  //                 SwitchListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   activeTrackColor: AppColors.secondary,
  //                   title: Text('Client Reviews & Feedback',
  //                       style: GoogleFonts.poppins(
  //                           fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
  //                   subtitle: Text('Get notified when users rate your plans or projects',
  //                       style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
  //                   value: _notifyReviews,
  //                   onChanged: (val) {
  //                     setSheetState(() => _notifyReviews = val);
  //                     setState(() => _notifyReviews = val);
  //                   },
  //                 ),
  //                 const Divider(height: 1),
  //                 SwitchListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   activeTrackColor: AppColors.secondary,
  //                   title: Text('System Announcements',
  //                       style: GoogleFonts.poppins(
  //                           fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
  //                   subtitle: Text('Platform updates and compliance guidelines',
  //                       style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
  //                   value: _notifySystem,
  //                   onChanged: (val) {
  //                     setSheetState(() => _notifySystem = val);
  //                     setState(() => _notifySystem = val);
  //                   },
  //                 ),
  //                 const Divider(height: 1),
  //                 SwitchListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   activeTrackColor: AppColors.secondary,
  //                   title: Text('Sound & Vibration',
  //                       style: GoogleFonts.poppins(
  //                           fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
  //                   subtitle: Text('Play sound on incoming urgent client inquiries',
  //                       style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
  //                   value: _soundEnabled,
  //                   onChanged: (val) {
  //                     setSheetState(() => _soundEnabled = val);
  //                     setState(() => _soundEnabled = val);
  //                   },
  //                 ),
  //                 const SizedBox(height: 20),
  //                 SizedBox(
  //                   width: double.infinity,
  //                   height: 46,
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(ctx);
  //                       _showSnackBar('Notification settings updated.');
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppColors.secondary,
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                     ),
  //                     child: Text('Save Preferences',
  //                         style: GoogleFonts.poppins(
  //                             fontWeight: FontWeight.bold, color: Colors.white)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
                    ? const Icon(Icons.check_circle, color: AppColors.secondary, size: 20)
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

  /// Displays Support & Guidelines dialog with issue reporting form.
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Contractor Support & Guidelines',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contractor Support',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
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
                        const Icon(Icons.email, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text('support@constructa.app',
                            style: GoogleFonts.poppins(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text('+91 98765 43210', style: GoogleFonts.poppins(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Constructor Guidelines',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                '1. Keep your company business profile updated.\n'
                '2. Respond to booking inquiries within 24 hours.\n'
                '3. Upload high-resolution 2D/3D house blueprints.\n'
                '4. Address customer reviews professionally.',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showReportIssueDialog();
                  },
                  icon: const Icon(Icons.report_problem_outlined, size: 16),
                  label: Text('Report an Issue',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: GoogleFonts.poppins(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }

  /// Displays issue reporting form for contractors.
  void _showReportIssueDialog() {
    final issueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report an Issue',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: issueController,
          maxLines: 4,
          style: GoogleFonts.poppins(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Describe the platform issue or contractor bug experienced...',
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
                _showSnackBar('Thank you! Your contractor report has been submitted.');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            child: Text('Submit',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: Text('Terms & Constructor Policy',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(
          child: Text(
            '1. Contractor Commitments:\nConstructors listed on Constructa agree to maintain accurate pricing and floor plan specifications.\n\n'
            '2. Booking Fulfillment:\nLead bookings confirmed by contractors represent preliminary project commitments.\n\n'
            '3. Data Rights & Privacy:\nCompany details and project portfolios are stored securely in Cloud Firestore & Firebase Storage.',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('I Understand',
                style: GoogleFonts.poppins(color: AppColors.secondary, fontWeight: FontWeight.bold)),
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
        title: Text('About Constructa',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.secondary,
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
            child: Text('Close', style: GoogleFonts.poppins(color: AppColors.secondary)),
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
        title: Text('Sign Out',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text('Are you sure you want to log out of your company account?',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger),
            child: Text('Log Out',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
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
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
