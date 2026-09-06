import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/company_service.dart';
import '../../../core/services/media_upload_service.dart';
import 'company_profile_screen.dart';
import 'manage_projects_screen.dart';
import 'constructor_reviews_screen.dart';

class ConstructorProfileScreen extends StatefulWidget {
  const ConstructorProfileScreen({super.key});

  @override
  State<ConstructorProfileScreen> createState() => _ConstructorProfileScreenState();
}

class _ConstructorProfileScreenState extends State<ConstructorProfileScreen> {
  bool _notifyBookings = true;
  bool _notifyReviews = true;
  bool _notifySystem = true;
  bool _soundEnabled = true;
  bool _isUploadingPhoto = false;

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
                'Change Profile Photo',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.secondary),
                title: Text('Choose From Gallery', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.gallery, uid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: Text('Take New Photo', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.camera, uid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.business_outlined, color: AppColors.textSecondary),
                title: Text('Edit Full Company Details', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
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

  Future<void> _pickAndUploadPhoto(ImageSource source, String uid) async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: source);
      if (file == null) return;

      setState(() => _isUploadingPhoto = true);

      // 1. Upload to ImgBB with automatic <= 3MB compression
      final url = await MediaUploadService().uploadImage(file);

      // 2. Update Company Profile
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

      // 3. Update Firebase Auth photo URL
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error uploading profile photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload photo: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Contractor Notification Settings',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage instant alerts for your construction business',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: AppColors.secondary,
                    title: Text('Booking Requests', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    subtitle: Text('Receive immediate alerts when clients book consultations', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    value: _notifyBookings,
                    onChanged: (val) {
                      setSheetState(() => _notifyBookings = val);
                      setState(() => _notifyBookings = val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: AppColors.secondary,
                    title: Text('Client Reviews & Feedback', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    subtitle: Text('Get notified when users rate your plans or projects', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    value: _notifyReviews,
                    onChanged: (val) {
                      setSheetState(() => _notifyReviews = val);
                      setState(() => _notifyReviews = val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: AppColors.secondary,
                    title: Text('System Announcements', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    subtitle: Text('Platform updates and compliance guidelines', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    value: _notifySystem,
                    onChanged: (val) {
                      setSheetState(() => _notifySystem = val);
                      setState(() => _notifySystem = val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: AppColors.secondary,
                    title: Text('Sound & Vibration', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    subtitle: Text('Play sound on incoming urgent client inquiries', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    value: _soundEnabled,
                    onChanged: (val) {
                      setSheetState(() => _soundEnabled = val);
                      setState(() => _soundEnabled = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notification settings updated.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Save Preferences', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;

        return StreamBuilder<CompanyModel?>(
          stream: CompanyService().getCompanyStream(uid),
          builder: (context, companySnapshot) {
            final company = companySnapshot.data;

            // Prioritize company logoUrl if set, then user profileImageUrl
            final String avatarUrl = (company?.logoUrl.isNotEmpty == true)
                ? company!.logoUrl
                : (user?.profileImageUrl.isNotEmpty == true ? user!.profileImageUrl : '');

            final String displayName = (company?.name.isNotEmpty == true)
                ? company!.name
                : (user?.fullName.isNotEmpty == true ? user!.fullName : 'BuildWell Constructions');

            final String displayEmail = (company?.email.isNotEmpty == true)
                ? company!.email
                : (user?.email.isNotEmpty == true ? user!.email : (FirebaseAuth.instance.currentUser?.email ?? 'contact@buildwell.com'));

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
                          GestureDetector(
                            onTap: _isUploadingPhoto ? null : () => _showPhotoOptions(context, uid),
                            child: Stack(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surfaceLight,
                                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3), width: 2),
                                  ),
                                  child: ClipOval(
                                    child: _isUploadingPhoto
                                        ? const Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary),
                                            ),
                                          )
                                        : (avatarUrl.isNotEmpty
                                            ? Image.network(
                                                avatarUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => const Icon(Icons.business_rounded, size: 36, color: AppColors.secondary),
                                              )
                                            : const Icon(Icons.business_rounded, size: 36, color: AppColors.secondary)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  displayEmail,
                                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withValues(alpha: 0.12),
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
                _buildProfileOption(
                  Icons.notifications_none,
                  'Notification Settings',
                  () => _showNotificationSettings(context),
                ),
                _buildProfileOption(Icons.help_outline, 'Contractor Support & Guidelines', () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Support & Guidelines', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Contractor Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('For any issues, contact us at support@constructa.app or call +91 98765 43210.', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                            const SizedBox(height: 16),
                            Text('Guidelines', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('1. Keep your company profile updated.\n2. Respond to booking requests within 24 hours.\n3. Maintain quality standards for all projects.\n4. Address customer reviews professionally.', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
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
                }),

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
