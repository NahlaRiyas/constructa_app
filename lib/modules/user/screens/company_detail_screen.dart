import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/services/project_service.dart';
import '../../../core/services/review_service.dart';
import 'house_plan_detail_screen.dart';
import 'project_detail_screen.dart';
import 'book_service_screen.dart';
import 'rate_review_screen.dart';

/// CompanyDetailScreen
///
/// Detailed company profile view with projects showcase, house plans listing, and customer reviews.
/// Employs MediaQuery throughout for responsive layout sizing and adaptive padding across device sizes.
class CompanyDetailScreen extends StatefulWidget {
  final CompanyModel company;
  const CompanyDetailScreen({super.key, required this.company});

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery Responsive Dimension & Sizing Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double appBarHeight = (h * 0.26).clamp(180.0, 280.0);
    final double logoSize = (w * 0.16).clamp(54.0, 76.0);
    final double companyNameFontSize = (w * 0.045).clamp(16.0, 22.0);
    final double bodyFontSize = (w * 0.034).clamp(11.0, 15.0);
    final double captionFontSize = (w * 0.030).clamp(10.0, 13.0);
    final double buttonHeight = (h * 0.058).clamp(42.0, 52.0);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // Company Banner App Bar
          SliverAppBar(
            expandedHeight: appBarHeight,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(color: Colors.white, size: (w * 0.06).clamp(20.0, 28.0)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.company.bannerUrl.isNotEmpty
                        ? widget.company.bannerUrl
                        : widget.company.logoUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Company Information Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.getCardBackground(context),
              padding: EdgeInsets.all(hPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        child: Image.network(
                          widget.company.logoUrl.isNotEmpty
                              ? widget.company.logoUrl
                              : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: w * 0.035),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.company.name,
                                    style: GoogleFonts.poppins(fontSize: companyNameFontSize, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                                  ),
                                ),
                                if (widget.company.isVerified)
                                  Icon(Icons.verified, color: AppColors.primary, size: (w * 0.05).clamp(18.0, 22.0)),
                              ],
                            ),
                            Text(widget.company.specialty, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context))),
                            SizedBox(height: h * 0.005),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: (w * 0.036).clamp(12.0, 16.0), color: AppColors.getTextSecondary(context)),
                                SizedBox(width: w * 0.005),
                                Expanded(child: Text(widget.company.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: captionFontSize, color: AppColors.getTextSecondary(context)))),
                                SizedBox(width: w * 0.02),
                                Icon(Icons.star, color: AppColors.starRating, size: (w * 0.04).clamp(14.0, 18.0)),
                                Text(' ${widget.company.rating} ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),
                                Text('(${widget.company.reviewCount})', style: GoogleFonts.poppins(fontSize: captionFontSize, color: AppColors.getTextSecondary(context))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.018),

                  if (widget.company.description.isNotEmpty) ...[
                    Text(widget.company.description, style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextSecondary(context), height: 1.4)),
                    SizedBox(height: h * 0.018),
                  ],

                  // Action Buttons (Book Consultation / Rate)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookServiceScreen(companyId: widget.company.id, companyName: widget.company.name, planId: '', planTitle: 'General Consultation'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.025)),
                            ),
                            icon: Icon(Icons.calendar_month, color: Colors.white, size: (w * 0.045).clamp(16.0, 20.0)),
                            label: Text('Book Service', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        height: buttonHeight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RateReviewScreen(
                                  companyId: widget.company.id,
                                  companyName: widget.company.name,
                                  targetId: widget.company.id,
                                  targetType: 'company',
                                  targetTitle: widget.company.name,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.025)),
                          ),
                          icon: Icon(Icons.rate_review_outlined, color: AppColors.primary, size: (w * 0.045).clamp(16.0, 20.0)),
                          label: Text('Rate', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar Header
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.getTextSecondary(context),
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.poppins(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: bodyFontSize),
                tabs: const [
                  Tab(text: 'Projects'),
                  Tab(text: 'House Plans'),
                  Tab(text: 'Reviews'),
                ],
              ),
              AppColors.getCardBackground(context),
            ),
          ),

          // Tab Body Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectsTab(context, w, h),
                _buildHousePlansTab(context, w, h),
                _buildReviewsTab(context, w, h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab(BuildContext context, double w, double h) {
    final double cardPadding = (w * 0.035).clamp(12.0, 18.0);
    final double bodyFontSize = (w * 0.034).clamp(11.0, 15.0);

    return StreamBuilder<List<ProjectModel>>(
      stream: ProjectService().getProjects(companyId: widget.company.id),
      builder: (context, snapshot) {
        final projects = snapshot.data ?? [];
        if (projects.isEmpty) {
          return Center(child: Text('No showcase projects available.', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: bodyFontSize)));
        }
        return ListView.builder(
          padding: EdgeInsets.all(cardPadding),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final proj = projects[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: proj)),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: h * 0.018),
                decoration: BoxDecoration(
                  color: AppColors.getCardBackground(context),
                  borderRadius: BorderRadius.circular(w * 0.04),
                  border: Border.all(color: AppColors.getBorderLight(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (proj.imageUrls.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.04)),
                        child: Image.network(
                          proj.imageUrls.first,
                          height: (h * 0.22).clamp(140.0, 220.0),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(proj.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: bodyFontSize * 1.15, color: AppColors.getTextPrimary(context))),
                          SizedBox(height: h * 0.005),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.004),
                                  decoration: BoxDecoration(
                                    color: AppColors.getSurfaceLight(context),
                                    borderRadius: BorderRadius.circular(w * 0.015),
                                  ),
                                  child: Text(proj.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: bodyFontSize * 0.85, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              Text(proj.completionDate, style: GoogleFonts.poppins(fontSize: bodyFontSize * 0.9, color: AppColors.getTextSecondary(context))),
                            ],
                          ),
                          if (proj.description.isNotEmpty) ...[
                            SizedBox(height: h * 0.008),
                            Text(proj.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: bodyFontSize * 0.9, color: AppColors.getTextSecondary(context))),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHousePlansTab(BuildContext context, double w, double h) {
    final double imageSize = (w * 0.18).clamp(60.0, 80.0);
    final double bodyFontSize = (w * 0.034).clamp(11.0, 15.0);

    return StreamBuilder<List<HousePlanModel>>(
      stream: HousePlanService().getCompanyHousePlans(widget.company.id),
      builder: (context, snapshot) {
        final plans = snapshot.data ?? [];
        if (plans.isEmpty) {
          return Center(child: Text('No house plans listed by this company.', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: bodyFontSize)));
        }
        return ListView.builder(
          padding: EdgeInsets.all(w * 0.04),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Container(
              margin: EdgeInsets.only(bottom: h * 0.015),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(w * 0.04),
                border: Border.all(color: AppColors.getBorderLight(context)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(w * 0.025),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(w * 0.025),
                  child: Image.network(
                    plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(plan.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: bodyFontSize)),
                subtitle: Text('${plan.bhk} • ${plan.sqft} sq.ft\nContract: ₹${(plan.contractPrice/100000).toStringAsFixed(1)} Lakhs', style: GoogleFonts.poppins(fontSize: bodyFontSize * 0.88, color: AppColors.getTextSecondary(context))),
                trailing: Icon(Icons.chevron_right, color: AppColors.primary, size: (w * 0.06).clamp(20.0, 26.0)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HousePlanDetailScreen(plan: plan)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsTab(BuildContext context, double w, double h) {
    final double bodyFontSize = (w * 0.034).clamp(11.0, 15.0);
    final double captionFontSize = (w * 0.030).clamp(10.0, 13.0);
    final double avatarRadius = (w * 0.045).clamp(16.0, 22.0);
    final double starSize = (w * 0.035).clamp(12.0, 16.0);

    return StreamBuilder<List<ReviewModel>>(
      stream: ReviewService().getCompanyReviews(widget.company.id),
      builder: (context, snapshot) {
        final reviews = snapshot.data ?? [];
        if (reviews.isEmpty) {
          return Center(child: Text('No reviews yet. Be the first to leave a review!', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: bodyFontSize)));
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final rev = reviews[index];
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
                        backgroundImage: rev.userAvatar.isNotEmpty ? NetworkImage(rev.userAvatar) : null,
                        child: rev.userAvatar.isEmpty ? Icon(Icons.person, size: avatarRadius, color: AppColors.getTextSecondary(context)) : null,
                      ),
                      SizedBox(width: w * 0.025),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rev.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),
                            Text(rev.createdAt, style: GoogleFonts.poppins(fontSize: captionFontSize, color: AppColors.getTextSecondary(context))),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: starSize,
                            color: i < rev.rating ? AppColors.starRating : AppColors.getBorderLight(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (rev.targetType != 'company') ...[
                    SizedBox(height: h * 0.008),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.004),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceLight(context),
                        borderRadius: BorderRadius.circular(w * 0.015),
                      ),
                      child: Text(
                        'Review for: ${rev.targetTitle}',
                        style: GoogleFonts.poppins(fontSize: captionFontSize, fontWeight: FontWeight.w600, color: AppColors.getTextSecondary(context)),
                      ),
                    ),
                  ],
                  SizedBox(height: h * 0.01),
                  Text(rev.comment, style: GoogleFonts.poppins(fontSize: bodyFontSize, color: AppColors.getTextPrimary(context))),

                  if (rev.response.isNotEmpty) ...[
                    SizedBox(height: h * 0.012),
                    Container(
                      padding: EdgeInsets.all(w * 0.025),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceLight(context),
                        borderRadius: BorderRadius.circular(w * 0.025),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Company Response', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: captionFontSize, color: AppColors.primary)),
                              const Spacer(),
                              Text(rev.responseDate, style: GoogleFonts.poppins(fontSize: captionFontSize * 0.9, color: AppColors.getTextSecondary(context))),
                            ],
                          ),
                          SizedBox(height: h * 0.003),
                          Text(rev.response, style: GoogleFonts.poppins(fontSize: bodyFontSize * 0.9, color: AppColors.getTextSecondary(context))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;
  _SliverAppBarDelegate(this._tabBar, this.backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
