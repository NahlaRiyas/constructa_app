import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';
import '../core/services/auth_service.dart';
import '../core/common/utils/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
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
    initScreenSize(context);

    final double cardWidth = w > 500 ? 440 : w * 0.92;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: height * 0.025),
            child: Container(
              width: cardWidth,
              padding: EdgeInsets.all(w * 0.06),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: height * 0.0125),
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Access customer services or company dashboard.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.032,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: height * 0.035),

                  Text('Email Address', style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  SizedBox(height: height * 0.0075),
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textSecondary),
                      hintText: 'name@company.com',
                      hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.0225),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password', style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                        child: Text('Forgot Password?', style: GoogleFonts.poppins(color: AppColors.primary, fontSize: w * 0.03, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    style: GoogleFonts.poppins(fontSize: w * 0.035, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      ),
                      hintText: '••••••••',
                      hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: w * 0.032),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),

                  SizedBox(
                    width: double.infinity,
                    height: height * 0.0625,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.textLight,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Login', style: GoogleFonts.poppins(fontSize: w * 0.0375, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.borderLight)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                        child: Text('OR CONTINUE WITH', style: GoogleFonts.poppins(fontSize: w * 0.025, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      ),
                      const Expanded(child: Divider(color: AppColors.borderLight)),
                    ],
                  ),
                  SizedBox(height: height * 0.025),

                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, height * 0.06),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.borderLight),
                    ),
                    icon: Image.network('https://e7.pngegg.com/pngimages/337/722/png-clipart-google-search-google-account-google-s-google-play-google-company-text-thumbnail.png', height: height * 0.035),
                    label: Text('Google Sign In', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: w * 0.038, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
                        child: Text('Sign Up', style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.primary, fontWeight: FontWeight.bold)),
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
