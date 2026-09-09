import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/common/utils/validation_utils.dart';

class EditUserProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditUserProfileScreen({super.key, required this.user});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.user.fullName;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phoneNumber;
  }

  void _pickImage() {
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
                'Choose Profile Photo',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: Text('Choose from Gallery', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _getImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.secondary),
                title: Text('Take New Photo', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _getImageFromSource(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.updateUserProfile(
        uid: widget.user.uid,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profileImage: _imageFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Dimension Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = w * 0.05;
    final double vPadding = h * 0.025;
    final double fieldGap = h * 0.02;
    final double titleFontSize = w * 0.035;
    final double inputFontSize = w * 0.038;
    final double avatarRadius = w * 0.12; // ~50dp
    final double buttonHeight = h * 0.06;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: w * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(fontSize: w * 0.043, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: AppColors.surfaceLight,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.user.profileImageUrl.isNotEmpty
                                ? NetworkImage(widget.user.profileImageUrl)
                                : null) as ImageProvider?,
                        child: _imageFile == null && widget.user.profileImageUrl.isEmpty
                            ? Icon(Icons.person, size: avatarRadius, color: AppColors.textSecondary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(w * 0.018),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, size: w * 0.045, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.035),

              // Full Name
              Text('Full Name', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              SizedBox(height: h * 0.008),
              TextFormField(
                controller: _fullNameController,
                style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
                validator: ValidationUtils.validateName,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary, size: w * 0.05),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
              SizedBox(height: fieldGap),

              // Email Address
              Text('Email Address', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              SizedBox(height: h * 0.008),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
                validator: ValidationUtils.validateEmail,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.textSecondary, size: w * 0.05),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
              SizedBox(height: fieldGap),

              // Phone Number
              Text('Phone Number', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              SizedBox(height: h * 0.008),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
                validator: ValidationUtils.validatePhone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: w * 0.05),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
              SizedBox(height: h * 0.045),

              // Update Button
              SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.03)),
                  ),
                  child: _isLoading
                      ? SizedBox(height: w * 0.05, width: w * 0.05, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Save Changes', style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
