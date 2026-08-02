import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../utils/global.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }
    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize global w and height via Media Query
    initScreenSize(context);

    // Responsive sizing calculated using MediaQuery dimensions w and height
    final double cardWidth = w > 420 ? 380 : w * 0.90;
    final double cardPadding = w > 360 ? 24.0 : 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: w > 400 ? 24.0 : 16.0,
              vertical: 20.0,
            ),
            child: Container(
              width: cardWidth,
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20.0),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Branding Icon Badge (Compass/Architecture)
                  Container(
                    width: w * 0.14,
                    height: w * 0.14,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.architecture,
                      color: AppColors.textLight,
                      size: w * 0.08,
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // App Name Title
                  Text(
                    'Constructa',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: height * 0.015),

                  // Heading Title
                  Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.0075),

                  // Subtitle Description
                  Text(
                    _isSubmitted
                        ? 'We have sent a password reset link to ${_emailController.text}. Please check your inbox.'
                        : 'Enter your email to receive a password reset link.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.032,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  if (!_isSubmitted) ...[
                    // Email Input Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.0075),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: AppColors.textSecondary,
                          size: w * 0.05,
                        ),
                        hintText: 'name@company.com',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: w * 0.032,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: height * 0.015,
                          horizontal: w * 0.04,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.06,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textLight,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send Reset Link',
                              style: GoogleFonts.poppins(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Icon(Icons.arrow_forward, size: w * 0.045),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Success Confirmation State
                    Container(
                      padding: EdgeInsets.all(w * 0.03),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.statusSuccess, size: w * 0.05),
                          SizedBox(width: w * 0.02),
                          Expanded(
                            child: Text(
                              'Reset link sent successfully!',
                              style: GoogleFonts.poppins(
                                fontSize: w * 0.03,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusSuccess,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                  ],

                  SizedBox(height: height * 0.025),

                  // Back to Login Button Link
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.0075, horizontal: w * 0.03),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: w * 0.04,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: w * 0.015),
                          Text(
                            'Back to Login',
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.032,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
