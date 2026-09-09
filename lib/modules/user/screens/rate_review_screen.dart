import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';
import '../../../core/services/auth_service.dart';

/// RateReviewScreen
///
/// Customer rating and review submission screen.
/// Employs MediaQuery throughout for responsive layout dimensions, paddings, and typography.
class RateReviewScreen extends StatefulWidget {
  final String companyId;
  final String companyName;
  final String targetId;
  final String targetType; // 'company', 'house_plan', or 'project'
  final String targetTitle;

  const RateReviewScreen({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.targetId,
    required this.targetType,
    required this.targetTitle,
  });

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a short review.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      String name = currentUser?.displayName ?? 'Anonymous User';
      if (name == 'Anonymous User' || name.isEmpty) {
        final userData = await AuthService().getUserData().first;
        if (userData != null) {
          name = userData.fullName;
        }
      }

      final review = ReviewModel(
        id: '',
        userId: currentUser?.uid ?? 'user_1',
        userName: name,
        userAvatar: currentUser?.photoURL ?? '',
        companyId: widget.companyId,
        companyName: widget.companyName,
        targetId: widget.targetId,
        targetType: widget.targetType,
        targetTitle: widget.targetTitle,
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now().toString().split(' ')[0],
      );

      await ReviewService().addReview(review);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for rating and reviewing!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: ${e.toString()}')),
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
    // MediaQuery Responsive Layout Sizing
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.05).clamp(16.0, 28.0);
    final double vPadding = (h * 0.02).clamp(12.0, 24.0);
    final double appBarTitleFontSize = (w * 0.045).clamp(16.0, 22.0);
    final double titleFontSize = (w * 0.05).clamp(18.0, 24.0);
    final double subtitleFontSize = (w * 0.035).clamp(12.0, 16.0);
    final double inputFontSize = (w * 0.036).clamp(12.0, 16.0);
    final double starIconSize = (w * 0.09).clamp(28.0, 42.0);
    final double buttonHeight = (h * 0.06).clamp(46.0, 56.0);
    final double borderRadius = (w * 0.03).clamp(10.0, 16.0);

    String headingPrefix = 'Rate your experience with';
    if (widget.targetType == 'house_plan') headingPrefix = 'Rate this House Plan';
    if (widget.targetType == 'project') headingPrefix = 'Rate this Project';

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(context), size: (w * 0.06).clamp(20.0, 28.0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Rate & Review', style: GoogleFonts.poppins(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.bold, fontSize: appBarTitleFontSize)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(headingPrefix, style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: AppColors.getTextSecondary(context))),
            SizedBox(height: h * 0.005),
            Text(widget.targetTitle, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.primary)),
            if (widget.targetType != 'company') ...[
              SizedBox(height: h * 0.005),
              Text('by ${widget.companyName}', style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: AppColors.getTextSecondary(context))),
            ],
            SizedBox(height: h * 0.025),

            // Star Rating Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  iconSize: starIconSize,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.008),
                  icon: Icon(
                    starValue <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.starRating,
                  ),
                  onPressed: () => setState(() => _rating = starValue.toDouble()),
                );
              }),
            ),
            SizedBox(height: h * 0.005),
            Text('$_rating out of 5.0 stars', style: GoogleFonts.poppins(fontSize: subtitleFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextSecondary(context))),
            SizedBox(height: h * 0.025),

            // Review text input
            TextField(
              controller: _commentController,
              maxLines: 4,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText: 'Share your thoughts and feedback...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: inputFontSize),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.all(w * 0.035),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: AppColors.getBorderLight(context))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: AppColors.getBorderLight(context))),
              ),
            ),
            SizedBox(height: h * 0.035),

            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Review', style: GoogleFonts.poppins(fontSize: (w * 0.04).clamp(14.0, 18.0), fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
