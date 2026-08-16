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
import 'book_service_screen.dart';
import 'rate_project_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Company Banner App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.company.bannerUrl.isNotEmpty
                        ? widget.company.bannerUrl
                        : 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.7)],
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
              color: AppColors.cardBackground,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.company.logoUrl.isNotEmpty
                              ? widget.company.logoUrl
                              : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.company.name,
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ),
                                if (widget.company.isVerified)
                                  const Icon(Icons.verified, color: AppColors.primary, size: 20),
                              ],
                            ),
                            Text(widget.company.specialty, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 2),
                                Text(widget.company.location, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                                const Spacer(),
                                const Icon(Icons.star, color: AppColors.starRating, size: 16),
                                Text(' ${widget.company.rating} ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                                Text('(${widget.company.reviewCount})', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (widget.company.description.isNotEmpty) ...[
                    Text(widget.company.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                    const SizedBox(height: 14),
                  ],

                  // Action Buttons (Book Consultation / Call / Rate)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookServiceScreen(companyId: widget.company.id, companyName: widget.company.name),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.calendar_month, color: Colors.white, size: 18),
                          label: Text('Book Service', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RateProjectScreen(companyId: widget.company.id, companyName: widget.company.name),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.rate_review_outlined, color: AppColors.primary, size: 18),
                        label: Text('Rate', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
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
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Projects'),
                  Tab(text: 'House Plans'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          // Tab Body Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectsTab(),
                _buildHousePlansTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return StreamBuilder<List<ProjectModel>>(
      stream: ProjectService().getProjects(companyId: widget.company.id),
      builder: (context, snapshot) {
        final projects = snapshot.data ?? [];
        if (projects.isEmpty) {
          return Center(child: Text('No showcase projects available.', style: GoogleFonts.poppins(color: AppColors.textSecondary)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final proj = projects[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (proj.imageUrls.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        proj.imageUrls.first,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(proj.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(proj.category, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                            const Spacer(),
                            Text(proj.completionDate, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        if (proj.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(proj.description, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHousePlansTab() {
    return StreamBuilder<List<HousePlanModel>>(
      stream: HousePlanService().getCompanyHousePlans(widget.company.id),
      builder: (context, snapshot) {
        final plans = snapshot.data ?? [];
        if (plans.isEmpty) {
          return Center(child: Text('No house plans listed by this company.', style: GoogleFonts.poppins(color: AppColors.textSecondary)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    plan.imageUrls.isNotEmpty ? plan.imageUrls.first : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQf65MSyJMwDSMBqTZOeY2TZ9QCFHql7Nqw50bZxUIBlsUGsL--5Dtccr8cXPXpPbKCOSVR9ubcV5g-zWVbMZFrJfaFeR4imxUXDnur-YzSnn7btzqd-8AnKbYoKsKzbJy1qNgTlYI5gkWUISP-oBynzQi_0RypArQCSfl_Xji23jKSNKyUYZVlt5wojNK9TG4quf2TR86xsRg-tHg9sUpynJDDz4XIaIxJgLYP6mho99U7StyO99v',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(plan.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${plan.bhk} • ${plan.sqft} sq.ft\nContract: ₹${(plan.contractPrice/100000).toStringAsFixed(1)} Lakhs', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
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

  Widget _buildReviewsTab() {
    return StreamBuilder<List<ReviewModel>>(
      stream: ReviewService().getCompanyReviews(widget.company.id),
      builder: (context, snapshot) {
        final reviews = snapshot.data ?? [];
        if (reviews.isEmpty) {
          return Center(child: Text('No reviews yet. Be the first to leave a review!', style: GoogleFonts.poppins(color: AppColors.textSecondary)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final rev = reviews[index];
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
                        backgroundImage: rev.userAvatar.isNotEmpty ? NetworkImage(rev.userAvatar) : null,
                        child: rev.userAvatar.isEmpty ? const Icon(Icons.person, size: 18, color: AppColors.textSecondary) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rev.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                            Text(rev.createdAt, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 14,
                            color: i < rev.rating ? AppColors.starRating : AppColors.borderLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(rev.comment, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),

                  if (rev.response.isNotEmpty) ...[
                    const SizedBox(height: 10),
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
                              Text('Company Response', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                              const Spacer(),
                              Text(rev.responseDate, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(rev.response, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
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
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.cardBackground,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
