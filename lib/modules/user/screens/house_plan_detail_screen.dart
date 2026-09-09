import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';
import 'book_service_screen.dart';
import 'rate_review_screen.dart';

/// HousePlanDetailScreen
///
/// Displays comprehensive architectural details, image gallery, blueprints,
/// contract price estimations, features, and user reviews for a specific house plan.
/// Employs MediaQuery throughout for responsive sizing and dynamic layout adaptation across device screen sizes.
class HousePlanDetailScreen extends StatefulWidget {
  final HousePlanModel plan;
  const HousePlanDetailScreen({super.key, required this.plan});

  @override
  State<HousePlanDetailScreen> createState() => _HousePlanDetailScreenState();
}

class _HousePlanDetailScreenState extends State<HousePlanDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _images {
    if (widget.plan.imageUrls.isNotEmpty) {
      return widget.plan.imageUrls;
    }
    return [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v'
    ];
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Dimension & Sizing Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double sectionGap = (h * 0.022).clamp(14.0, 24.0);
    final double appBarHeight = (h * 0.35).clamp(240.0, 380.0);
    final double titleFontSize = (w * 0.055).clamp(18.0, 26.0);
    final double sectionHeaderFontSize = (w * 0.042).clamp(14.0, 20.0);
    final double bodyFontSize = (w * 0.034).clamp(11.0, 15.0);
    final double captionFontSize = (w * 0.030).clamp(10.0, 13.0);
    final double priceFontSize = (w * 0.052).clamp(18.0, 24.0);
    final double buttonHeight = (h * 0.062).clamp(46.0, 56.0);
    final double thumbnailSize = (w * 0.22).clamp(70.0, 100.0);

    final images = _images;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // Multi-Image Carousel Header (SliverAppBar with MediaQuery dimensions)
          SliverAppBar(
            expandedHeight: appBarHeight,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(color: Colors.white, size: (w * 0.06).clamp(20.0, 28.0)),
            actions: [
              if (images.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white, size: (w * 0.06).clamp(20.0, 28.0)),
                  tooltip: 'View Fullscreen Blueprints & Photos',
                  onPressed: () {
                    FullscreenImageViewer.open(
                      context,
                      imageUrls: images,
                      initialIndex: _currentImageIndex,
                      title: widget.plan.title,
                    );
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          FullscreenImageViewer.open(
                            context,
                            imageUrls: images,
                            initialIndex: index,
                            title: widget.plan.title,
                          );
                        },
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceLight,
                            child: Icon(Icons.architecture, size: (w * 0.12).clamp(36.0, 60.0), color: AppColors.textMuted),
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: h * 0.08,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Photo counter badge
                  if (images.length > 1)
                    Positioned(
                      bottom: h * 0.015,
                      right: hPadding,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(w * 0.03),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library, size: (w * 0.032).clamp(10.0, 14.0), color: Colors.white),
                            SizedBox(width: w * 0.01),
                            Text(
                              '${_currentImageIndex + 1} / ${images.length}',
                              style: GoogleFonts.poppins(fontSize: captionFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Page dot indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: h * 0.02,
                      left: hPadding,
                      child: Row(
                        children: List.generate(images.length, (i) {
                          final isSelected = i == _currentImageIndex;
                          return Container(
                            margin: EdgeInsets.only(right: w * 0.01),
                            width: isSelected ? w * 0.04 : w * 0.015,
                            height: h * 0.008,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(h * 0.004),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(hPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags Wrap
                  Wrap(
                    spacing: w * 0.02,
                    runSpacing: h * 0.01,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(w * 0.02),
                        ),
                        child: Text(widget.plan.bhk, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: captionFontSize)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(w * 0.02),
                        ),
                        child: Text('${widget.plan.sqft} sq.ft', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: captionFontSize)),
                      ),
                      if (widget.plan.tag.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.005),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(w * 0.02),
                          ),
                          child: Text(widget.plan.tag.toUpperCase(), style: GoogleFonts.poppins(fontSize: captionFontSize * 0.85, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),

                  Text(widget.plan.title, style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                  if (widget.plan.companyName.isNotEmpty) ...[
                    SizedBox(height: h * 0.005),
                    Text('Designed & Built by ${widget.plan.companyName}', style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context))),
                  ],
                  SizedBox(height: sectionGap),

                  // Contract Price Card
                  Container(
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      color: AppColors.getCardBackground(context),
                      borderRadius: BorderRadius.circular(w * 0.04),
                      border: Border.all(color: AppColors.getBorderLight(context)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimated Contract Price', style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context))),
                              SizedBox(height: h * 0.003),
                              Text(
                                '₹${(widget.plan.contractPrice / 100000).toStringAsFixed(2)} Lakhs',
                                style: GoogleFonts.poppins(fontSize: priceFontSize, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.verified_user_outlined, color: AppColors.primary, size: (w * 0.07).clamp(24.0, 32.0)),
                      ],
                    ),
                  ),
                  SizedBox(height: sectionGap),

                  // Architectural Blueprints & Design Gallery (Multi-Image Showcase)
                  if (images.length > 1) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Floor Plans & 3D Renders (${images.length})', style: GoogleFonts.poppins(fontSize: w*0.042, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                        ),
                        TextButton(
                          onPressed: () {
                            FullscreenImageViewer.open(
                              context,
                              imageUrls: images,
                              initialIndex: _currentImageIndex,
                              title: widget.plan.title,
                            );
                          },
                          child: Text('Inspect All', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.01),
                    SizedBox(
                      height: thumbnailSize,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        separatorBuilder: (_, __) => SizedBox(width: w * 0.025),
                        itemBuilder: (context, idx) {
                          final isCurrent = idx == _currentImageIndex;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                idx,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: thumbnailSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.025),
                                border: Border.all(
                                  color: isCurrent ? AppColors.secondary : AppColors.getBorderLight(context),
                                  width: isCurrent ? 2.5 : 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(w * 0.02),
                                child: Image.network(images[idx], fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: sectionGap),
                  ],

                  Text('Overview & Architecture', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                  SizedBox(height: h * 0.01),
                  Text(
                    widget.plan.description.isNotEmpty
                        ? widget.plan.description
                        : 'Custom architectural plan engineered for optimal space utilization, modern structural aesthetics, and efficient construction timeline.',
                    style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context), height: 1.5),
                  ),
                  SizedBox(height: sectionGap),

                  if (widget.plan.features.isNotEmpty) ...[
                    Text('Key Features & Specifications', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                    SizedBox(height: h * 0.012),
                    Wrap(
                      spacing: w * 0.02,
                      runSpacing: h * 0.01,
                      children: widget.plan.features.map((feat) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.01),
                          decoration: BoxDecoration(
                            color: AppColors.getCardBackground(context),
                            borderRadius: BorderRadius.circular(w * 0.025),
                            border: Border.all(color: AppColors.getBorderLight(context)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline, size: (w * 0.04).clamp(14.0, 18.0), color: AppColors.statusSuccess),
                              SizedBox(width: w * 0.015),
                              Text(feat, style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: sectionGap * 1.2),
                  ],

                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('User Reviews', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RateReviewScreen(
                                companyId: widget.plan.companyId,
                                companyName: widget.plan.companyName,
                                targetId: widget.plan.id,
                                targetType: 'house_plan',
                                targetTitle: widget.plan.title,
                              ),
                            ),
                          );
                        },
                        child: Text('Write Review', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),

                  StreamBuilder<List<ReviewModel>>(
                    stream: ReviewService().getReviews(targetId: widget.plan.id, targetType: 'house_plan'),
                    builder: (context, snapshot) {
                      final reviews = snapshot.data ?? [];
                      if (reviews.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: h * 0.025),
                            child: Text('No reviews for this plan yet.', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: bodyFontSize)),
                          ),
                        );
                      }

                      return Column(
                        children: reviews.map((rev) => _buildReviewCard(context, rev)).toList(),
                      );
                    },
                  ),
                  SizedBox(height: h * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(hPadding),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          border: Border(top: BorderSide(color: AppColors.getBorderLight(context))),
        ),
        child: SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookServiceScreen(
                    companyId: widget.plan.companyId,
                    companyName: widget.plan.companyName,
                    planId: widget.plan.id,
                    planTitle: widget.plan.title,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.03)),
            ),
            child: Text(
              'Book Construction Service',
              style: GoogleFonts.poppins(
                fontSize: (w * 0.04).clamp(14.0, 18.0),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, ReviewModel review) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final bodyFontSize = (w * 0.034).clamp(11.0, 15.0);
    final captionFontSize = (w * 0.030).clamp(10.0, 13.0);
    final avatarRadius = (w * 0.045).clamp(16.0, 22.0);
    final starSize = (w * 0.035).clamp(12.0, 16.0);

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(w * 0.035),
        border: Border.all(color: AppColors.getBorderLight(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.surfaceLight,
                backgroundImage: review.userAvatar.isNotEmpty ? NetworkImage(review.userAvatar) : null,
                child: review.userAvatar.isEmpty ? Icon(Icons.person, size: avatarRadius, color: AppColors.getTextSecondary(context)) : null,
              ),
              SizedBox(width: w * 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),
                    Text(review.createdAt, style: GoogleFonts.poppins(fontSize: captionFontSize, color: AppColors.getTextSecondary(context))),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: starSize,
                    color: i < review.rating ? AppColors.starRating : AppColors.getBorderLight(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Text(review.comment, style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),
        ],
      ),
    );
  }
}
