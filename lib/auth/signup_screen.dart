import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/palette.dart';
import '../core/services/auth_service.dart';
import '../core/services/company_service.dart';
import '../core/models/company_model.dart';
import '../core/common/utils/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  bool _isLoading = false;
  bool _isCustomer = true;
  bool _agreedToTerms = true;
  bool _obscurePassword = true;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleSignUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms to proceed.')),
      );
      return;
    }

    if (_fullNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final role = _isCustomer ? 'customer' : 'company';
      final cred = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        role: role,
        profileImage: _imageFile,
      );

      if (cred?.user != null && role == 'company') {
        // Initialize Company record in Firestore
        final compService = CompanyService();
        await compService.saveCompanyProfile(
          CompanyModel(
            id: cred!.user!.uid,
            uid: cred.user!.uid,
            name: _fullNameController.text.trim(),
            specialty: 'Construction & Architectural Services',
            location: 'Kochi, Kerala',
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
          ),
        );
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'email-already-in-use') {
        // Attempt to log in with provided password and update role to company
        try {
          final loginCred = await _authService.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          if (loginCred?.user != null) {
            final targetRole = _isCustomer ? 'customer' : 'company';
            await _authService.updateUserRole(loginCred!.user!.uid, targetRole);

            if (targetRole == 'company') {
              final compService = CompanyService();
              await compService.saveCompanyProfile(
                CompanyModel(
                  id: loginCred.user!.uid,
                  uid: loginCred.user!.uid,
                  name: _fullNameController.text.trim().isNotEmpty
                      ? _fullNameController.text.trim()
                      : 'BuildWell Constructions',
                  specialty: 'Construction & Architectural Services',
                  location: 'Kochi, Kerala',
                  email: _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                ),
              );
            }

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Account existed. Logged in & updated role to ${targetRole == "company" ? "Constructor Company" : "Customer"}.')),
            );
            Navigator.pushReplacementNamed(context, '/home');
            return;
          }
        } catch (_) {
          // If login with provided password fails
        }

        // Show helpful dialog
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: Text('Email Already Registered',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            content: Text(
              'The email "${_emailController.text.trim()}" is already registered in Firebase.\n\n'
              'If this is your account, please tap "Go to Login" to sign in directly.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text('Go to Login',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sign up failed: ${e.message ?? e.toString()}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms to proceed.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign up failed: ${e.toString()}')),
      );
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    final double cardWidth = w > 500 ? 460 : w * 0.92;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Constructa',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: w * 0.05, vertical: height * 0.015),
            child: Container(
              width: cardWidth,
              padding: EdgeInsets.all(w * 0.05),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  // PROFILE PICTURE PICKER
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: w * 0.1,
                          backgroundColor: AppColors.surfaceLight,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : null,
                          child: _imageFile == null
                              ? Icon(Icons.person,
                                  size: w * 0.1, color: AppColors.textSecondary)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt,
                                  size: w * 0.04, color: AppColors.textLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // ROLE TOGGLE (Customer vs Construction Company)
                  Container(
                    padding: EdgeInsets.all(w * 0.01),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isCustomer = true),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.0125),
                              decoration: BoxDecoration(
                                color: _isCustomer
                                    ? AppColors.primary
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'User / Customer',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: w * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: _isCustomer
                                      ? AppColors.textLight
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isCustomer = false),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.0125),
                              decoration: BoxDecoration(
                                color: !_isCustomer
                                    ? AppColors.secondary
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Constructor Co.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: w * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: !_isCustomer
                                      ? AppColors.textLight
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  Text(
                    _isCustomer ? 'Full Name' : 'Company / Business Name',
                    style: GoogleFonts.poppins(
                        fontSize: w * 0.03,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  SizedBox(height: height * 0.005),
                  TextField(
                    controller: _fullNameController,
                    style: GoogleFonts.poppins(
                        fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          _isCustomer ? Icons.person_outline : Icons.business,
                          color: AppColors.textSecondary),
                      hintText:
                          _isCustomer ? 'John Doe' : 'BuildWell Constructions',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  SizedBox(height: height * 0.015),

                  Text('Email Address',
                      style: GoogleFonts.poppins(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  SizedBox(height: height * 0.005),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(
                        fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_outline,
                          color: AppColors.textSecondary),
                      hintText: 'name@example.com',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  SizedBox(height: height * 0.015),

                  Text('Phone Number',
                      style: GoogleFonts.poppins(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  SizedBox(height: height * 0.005),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.poppins(
                        fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined,
                          color: AppColors.textSecondary),
                      hintText: '+91 98765 43210',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  SizedBox(height: height * 0.015),

                  Text('Password',
                      style: GoogleFonts.poppins(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  SizedBox(height: height * 0.005),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.poppins(
                        fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      hintText: '••••••••',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  SizedBox(height: height * 0.015),

                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) =>
                            setState(() => _agreedToTerms = val ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms of Service & Privacy Policy.',
                          style: GoogleFonts.poppins(
                              fontSize: w * 0.028,
                              color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  SizedBox(
                    width: double.infinity,
                    height: height * 0.06,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCustomer
                            ? AppColors.primary
                            : AppColors.secondary,
                        foregroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: AppColors.textLight, strokeWidth: 2))
                          : Text(
                              'Create ${_isCustomer ? "User" : "Constructor"} Account',
                              style: GoogleFonts.poppins(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style: GoogleFonts.poppins(
                              fontSize: w * 0.032,
                              color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text('Login',
                            style: GoogleFonts.poppins(
                                fontSize: w * 0.032,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
