import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/review_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';
import 'rate_review_screen.dart';

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
    final images = _images;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Multi-Image Carousel Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              if (images.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
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
                            child: const Icon(Icons.broken_image, size: 50, color: AppColors.textMuted),
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark gradient overlay for title legibility
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
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
                      bottom: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo_library, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${_currentImageIndex + 1} / ${images.length}',
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Page dot indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: List.generate(images.length, (i) {
                          final isSelected = i == _currentImageIndex;
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            width: isSelected ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(widget.project.category, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                  ),
                  const SizedBox(height: 12),

                  Text(widget.project.title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(widget.project.location, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text('Project Overview', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description.isNotEmpty
                        ? widget.project.description
                        : 'A premium construction project showcasing exceptional architectural design and engineering excellence.',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Text('Completed on: ${widget.project.completionDate}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 20),

                  // Architectural & Site Gallery Section (Multi-Image Showcase)
                  if (images.length > 1) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Project Gallery (${images.length} Photos)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        TextButton(
                          onPressed: () {
                            FullscreenImageViewer.open(
                              context,
                              imageUrls: images,
                              initialIndex: _currentImageIndex,
                              title: widget.project.title,
                            );
                          },
                          child: Text('View All', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
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
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isCurrent ? AppColors.secondary : AppColors.borderLight,
                                  width: isCurrent ? 2.5 : 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(images[idx], fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Project Reviews', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                        child: Text('Rate Project', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  StreamBuilder<List<ReviewModel>>(
                    stream: ReviewService().getReviews(targetId: widget.project.id, targetType: 'project'),
                    builder: (context, snapshot) {
                      final reviews = snapshot.data ?? [];
                      if (reviews.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text('No reviews for this project yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
                          ),
                        );
                      }

                      return Column(
                        children: reviews.map((rev) => _buildReviewCard(rev)).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
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
        ],
      ),
    );
  }
}
