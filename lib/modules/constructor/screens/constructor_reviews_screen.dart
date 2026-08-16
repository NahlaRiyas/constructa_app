import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';

class ConstructorReviewsScreen extends StatelessWidget {
  const ConstructorReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? 'comp_1';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Customer Ratings & Feedback', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewService().getCompanyReviews(companyUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return Center(
              child: Text('No customer reviews posted yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final r = reviews[index];
              return _buildReviewTile(context, r);
            },
          );
        },
      ),
    );
  }

  Widget _buildReviewTile(BuildContext context, ReviewModel review) {
    final TextEditingController responseController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceLight,
                backgroundImage: review.userAvatar.isNotEmpty ? NetworkImage(review.userAvatar) : null,
                child: review.userAvatar.isEmpty ? const Icon(Icons.person, size: 18, color: AppColors.textSecondary) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                    Text(review.createdAt, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 14,
                    color: i < review.rating ? AppColors.starRating : AppColors.borderLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 10),

          if (review.response.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Your Official Response', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.secondary)),
                      const Spacer(),
                      Text(review.responseDate, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(review.response, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            )
          else
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Respond to Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                      content: TextField(
                        controller: responseController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Type your official response here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (responseController.text.trim().isNotEmpty) {
                              await ReviewService().respondToReview(review.id, responseController.text.trim());
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Response posted!')));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                          child: const Text('Submit Response', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.reply, size: 16, color: AppColors.secondary),
              label: Text('Respond to Review', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ),
        ],
      ),
    );
  }
}
