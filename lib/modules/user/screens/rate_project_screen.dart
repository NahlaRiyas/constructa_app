import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';

class RateProjectScreen extends StatefulWidget {
  final String companyId;
  final String companyName;

  const RateProjectScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<RateProjectScreen> createState() => _RateProjectScreenState();
}

class _RateProjectScreenState extends State<RateProjectScreen> {
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
      final review = ReviewModel(
        id: '',
        userId: currentUser?.uid ?? 'user_1',
        userName: currentUser?.displayName ?? 'Anonymous User',
        userAvatar: currentUser?.photoURL ?? '',
        companyId: widget.companyId,
        companyName: widget.companyName,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Rate & Review Builder', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Rate your experience with', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(widget.companyName, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 24),

            // Star Rating Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  iconSize: 36,
                  icon: Icon(
                    starValue <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.starRating,
                  ),
                  onPressed: () => setState(() => _rating = starValue.toDouble()),
                );
              }),
            ),
            Text('$_rating out of 5.0 stars', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Review text input
            TextField(
              controller: _commentController,
              maxLines: 4,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Share details about the construction quality, timeline, communication, and overall service...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Review', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
