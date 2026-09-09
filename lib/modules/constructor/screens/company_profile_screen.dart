import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/services/company_service.dart';
import '../../../core/services/media_upload_service.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _logoUrlController = TextEditingController();

  XFile? _selectedLogoFile;
  bool _isLoading = false;
  String _uploadStatus = '';

  final CompanyService _companyService = CompanyService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final comp = await _companyService.getCompanyById(uid);
    if (comp != null) {
      _nameController.text = comp.name;
      _specialtyController.text = comp.specialty;
      _locationController.text = comp.location;
      _descriptionController.text = comp.description;
      _phoneController.text = comp.phone;
      _emailController.text = comp.email;
      _logoUrlController.text = comp.logoUrl;
      if (mounted) setState(() {});
    }
  }

  Future<void> _pickLogo() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _selectedLogoFile = file;
        });
      }
    } catch (e) {
      debugPrint('Error picking logo: $e');
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter company name.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadStatus = 'Saving profile...';
    });

    try {
      String logoUrl = _logoUrlController.text.trim();

      if (_selectedLogoFile != null) {
        setState(() => _uploadStatus = 'Uploading company logo...');
        logoUrl = await MediaUploadService().uploadImage(_selectedLogoFile!);
      }

      final comp = CompanyModel(
        id: uid,
        uid: uid,
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        logoUrl: logoUrl,
      );

      await _companyService.saveCompanyProfile(comp);

      if (logoUrl.isNotEmpty) {
        try {
          await FirebaseAuth.instance.currentUser?.updatePhotoURL(logoUrl);
        } catch (e) {
          debugPrint('Error updating FirebaseAuth photoURL: $e');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company profile updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _uploadStatus = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Dimension Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = w * 0.04;
    final double vPadding = h * 0.02;
    final double fieldGap = h * 0.018;
    final double titleFontSize = w * 0.033;
    final double inputFontSize = w * 0.036;
    final double buttonHeight = h * 0.06;
    final double logoSize = w * 0.22; // ~90dp

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: w * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Company Profile Setup', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: w * 0.043)),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(hPadding, vPadding, hPadding, h * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo Upload Avatar Card
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickLogo,
                    child: Stack(
                      children: [
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderLight, width: 2),
                          ),
                          child: ClipOval(
                            child: _selectedLogoFile != null
                                ? (kIsWeb
                                    ? FutureBuilder<Uint8List>(
                                        future: _selectedLogoFile!.readAsBytes(),
                                        builder: (context, snap) => snap.hasData ? Image.memory(snap.data!, fit: BoxFit.cover) : const SizedBox(),
                                      )
                                    : Image.file(File(_selectedLogoFile!.path), fit: BoxFit.cover))
                                : (_logoUrlController.text.isNotEmpty
                                    ? Image.network(
                                        _logoUrlController.text,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.business, size: logoSize * 0.45, color: AppColors.secondary),
                                      )
                                    : Icon(Icons.business, size: logoSize * 0.45, color: AppColors.secondary)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(w * 0.015),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white, size: w * 0.038),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),

            Text('Company Name', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _nameController,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'BuildWell Constructions',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Text('Specialty / Category', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _specialtyController,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Residential & Villa Design',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Text('City / Operating Location', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _locationController,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Kochi, Kerala',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Text('Contact Phone Number', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '+91 98765 43210',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Text('Official Email Address', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'contact@buildwell.com',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Text('Company Overview & Bio', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Premier construction firm with 10+ years of structural design and luxury villa construction...',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap * 1.5),

            if (_isLoading && _uploadStatus.isNotEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: h * 0.015),
                  child: Text(_uploadStatus, style: GoogleFonts.poppins(fontSize: w * 0.03, color: AppColors.secondary)),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.03)),
                ),
                child: _isLoading
                    ? SizedBox(height: w * 0.05, width: w * 0.05, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Save Company Profile', style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
