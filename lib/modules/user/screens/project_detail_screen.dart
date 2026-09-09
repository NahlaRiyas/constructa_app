import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';
import 'rate_review_screen.dart';

/// ProjectDetailScreen
///
/// Displays project details, photo gallery, location specs, and customer reviews.
/// Employs MediaQuery throughout for responsive sizing and dynamic layout adaptation across device screen sizes.
class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _images {
    if (widget.project.imageUrls.isNotEmpty) {
      return widget.project.imageUrls;
    }
    return ['https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=800'];
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
                  tooltip: 'View Fullscreen Gallery',
                  onPressed: () {
                    FullscreenImageViewer.open(
                      context,
                      imageUrls: images,
                      initialIndex: _currentImageIndex,
                      title: widget.project.title,
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
                            title: widget.project.title,
                          );
                        },
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceLight,
                            child: Icon(Icons.broken_image, size: (w * 0.12).clamp(36.0, 60.0), color: AppColors.textMuted),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: Text(widget.project.category, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: captionFontSize)),
                  ),
                  SizedBox(height: h * 0.015),

                  Text(widget.project.title, style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                  SizedBox(height: h * 0.005),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: (w * 0.04).clamp(14.0, 18.0), color: AppColors.getTextSecondary(context)),
                      SizedBox(width: w * 0.01),
                      Expanded(
                        child: Text(
                          widget.project.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sectionGap),

                  Text('Project Overview', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                  SizedBox(height: h * 0.01),
                  Text(
                    widget.project.description.isNotEmpty
                        ? widget.project.description
                        : 'A premium construction project showcasing exceptional architectural design and engineering excellence.',
                    style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context), height: 1.5),
                  ),
                  SizedBox(height: h * 0.015),
                  Text('Completed on: ${widget.project.completionDate}', style: GoogleFonts.poppins(fontSize: bodyFontSize, fontWeight: FontWeight.w600, color: AppColors.getTextPrimary(context))),
                  SizedBox(height: sectionGap),

                  // Architectural & Site Gallery Section
                  if (images.length > 1) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Project Gallery (${images.length} Photos)', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                        ),
                        TextButton(
                          onPressed: () {
                            FullscreenImageViewer.open(
                              context,
                              imageUrls: images,
                              initialIndex: _currentImageIndex,
                              title: widget.project.title,
                            );
                          },
                          child: Text('View All', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
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

                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Project Reviews', style: GoogleFonts.poppins(fontSize: sectionHeaderFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RateReviewScreen(
                                companyId: widget.project.companyId,
                                companyName: widget.project.companyName,
                                targetId: widget.project.id,
                                targetType: 'project',
                                targetTitle: widget.project.title,
                              ),
                            ),
                          );
                        },
                        child: Text('Rate Project', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),

                  StreamBuilder<List<ReviewModel>>(
                    stream: ReviewService().getReviews(targetId: widget.project.id, targetType: 'project'),
                    builder: (context, snapshot) {
                      final reviews = snapshot.data ?? [];
                      if (reviews.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: h * 0.025),
                            child: Text('No reviews for this project yet.', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: bodyFontSize)),
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
