import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';
import '../core/services/auth_service.dart';
import '../core/common/utils/global.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleReset() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService().resetPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending reset email: ${e.toString()}')),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reset Password', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Forgot your password?',
                style: GoogleFonts.poppins(fontSize: w * 0.055, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Enter your registered email address below to receive password reset instructions.',
                style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.textSecondary),
              ),
              SizedBox(height: height * 0.03),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(fontSize: w * 0.035, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textSecondary),
                  hintText: 'name@example.com',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: w * 0.032),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
              SizedBox(height: height * 0.03),

              SizedBox(
                height: height * 0.06,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.textLight)
                      : Text('Send Reset Link', style: GoogleFonts.poppins(fontSize: w * 0.035, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
