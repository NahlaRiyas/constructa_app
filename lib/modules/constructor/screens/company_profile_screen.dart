import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/services/company_service.dart';

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
  bool _isLoading = false;

  final CompanyService _companyService = CompanyService();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
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

    setState(() => _isLoading = true);

    try {
      final comp = CompanyModel(
        id: uid,
        uid: uid,
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        logoUrl: _logoUrlController.text.trim(),
      );

      await _companyService.saveCompanyProfile(comp);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Company Profile Setup', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company Name', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _nameController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'BuildWell Constructions',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Specialty / Category', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _specialtyController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Residential & Villa Design',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('City / Operating Location', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _locationController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Kochi, Kerala',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Business Contact Phone', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '+91 98765 43210',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Business Email', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'contact@buildwell.com',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Company Logo / Image URL', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _logoUrlController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'https://...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Company Overview & Bio', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Premier construction firm with 10+ years of structural design and luxury villa construction...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Profile Changes', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
