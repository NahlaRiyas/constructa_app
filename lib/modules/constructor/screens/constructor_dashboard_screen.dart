import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/company_service.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/services/project_service.dart';
import '../../../core/services/review_service.dart';
import 'add_edit_house_plan_screen.dart';
import 'add_edit_project_screen.dart';
import 'company_profile_screen.dart';

class ConstructorDashboardScreen extends StatefulWidget {
  const ConstructorDashboardScreen({super.key});

  @override
  State<ConstructorDashboardScreen> createState() => _ConstructorDashboardScreenState();
}

class _ConstructorDashboardScreenState extends State<ConstructorDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, userSnap) {
        final companyUser = userSnap.data;

        return StreamBuilder<CompanyModel?>(
          stream: CompanyService().getCompanyStream(companyUid),
          builder: (context, compSnap) {
            final company = compSnap.data;
            final companyName = (company?.name.isNotEmpty == true)
                ? company!.name
                : (companyUser?.fullName.isNotEmpty == true
                    ? companyUser!.fullName
                    : 'BuildWell Constructions');
            final avatarUrl = (company?.logoUrl.isNotEmpty == true)
                ? company!.logoUrl
                : (companyUser?.profileImageUrl.isNotEmpty == true
                    ? companyUser!.profileImageUrl
                    : '');

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.cardBackground,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Constructor Console',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary)),
                    Text(companyName,
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: AppColors.secondary),
                    tooltip: 'Edit Company Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyProfileScreen()),
                      );
                    },
                  ),
                  if (avatarUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompanyProfileScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.surfaceLight,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------------
                    // 1. HERO GRADIENT CONSOLE BANNER WITH PULSE BADGE
                    // ---------------------------------------------------------
                    _buildHeroBanner(companyName),
                    const SizedBox(height: 20),

                    // ---------------------------------------------------------
                    // 2. ANIMATED METRICS OVERVIEW GRID
                    // ---------------------------------------------------------
                    _buildLiveMetricsGrid(companyUid),
                    const SizedBox(height: 24),

                    // ---------------------------------------------------------
                    // 3. QUICK MANAGEMENT ACTIONS WITH ANIMATED CARDS
                    // ---------------------------------------------------------
                    Text('Quick Actions',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.add_home_work,
                            label: 'Add House Plan',
                            color: AppColors.secondary,
                            isFilled: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddEditHousePlanScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.add_a_photo_outlined,
                            label: 'Add Project',
                            color: AppColors.secondary,
                            isFilled: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddEditProjectScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ---------------------------------------------------------
                    // 4. INCOMING BOOKING REQUESTS FEED
                    // ---------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Incoming Booking Requests',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        Row(
                          children: [
                            FadeTransition(
                              opacity: Tween<double>(begin: 0.3, end: 1.0)
                                  .animate(_pulseController),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.statusSuccess,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('Real-time',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.statusSuccess,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    StreamBuilder<List<BookingModel>>(
                      stream: BookingService().getCompanyBookings(companyUid),
                      builder: (context, bookingSnap) {
                        if (bookingSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ));
                        }

                        final bookings = bookingSnap.data ?? [];
                        if (bookings.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.event_available,
                                    size: 40, color: AppColors.textMuted),
                                const SizedBox(height: 8),
                                Text('No booking requests received yet.',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textSecondary,
                                        fontSize: 13)),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: bookings.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final booking = entry.value;
                            return _buildAnimatedBookingRequestTile(
                                context, booking, idx);
                          }).toList(),
                        );
                      },
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

  /// Builds a gradient hero welcome banner for the constructor console.
  Widget _buildHeroBanner(String companyName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.construction,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white70)),
                    Text(companyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Manage customer inquiries, showcase completed projects, and publish 2D/3D house blueprints in real-time.',
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.white.withValues(alpha: 0.85), height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Streams metrics and renders animated 2x2 grid of metric cards.
  Widget _buildLiveMetricsGrid(String companyUid) {
    return StreamBuilder<List<BookingModel>>(
      stream: BookingService().getCompanyBookings(companyUid),
      builder: (context, bookingSnap) {
        final bookings = bookingSnap.data ?? [];
        final activeBookings = bookings
            .where((b) => b.status != 'Cancelled' && b.status != 'Completed')
            .length;

        return StreamBuilder<List<HousePlanModel>>(
          stream: HousePlanService().getCompanyHousePlans(companyUid),
          builder: (context, planSnap) {
            final plans = planSnap.data ?? [];

            return StreamBuilder<List<ProjectModel>>(
              stream: ProjectService().getProjects(companyId: companyUid),
              builder: (context, projectSnap) {
                final projects = projectSnap.data ?? [];

                return StreamBuilder<List<ReviewModel>>(
                  stream: ReviewService().getCompanyReviews(companyUid),
                  builder: (context, reviewSnap) {
                    final reviews = reviewSnap.data ?? [];
                    final avgRating = reviews.isNotEmpty
                        ? (reviews
                                .map((r) => r.rating)
                                .reduce((a, b) => a + b) /
                            reviews.length)
                        : 0.0;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedMetricCard(
                                title: 'Active Leads',
                                value: '$activeBookings',
                                icon: Icons.assignment_turned_in,
                                color: AppColors.secondary,
                                index: 0,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedMetricCard(
                                title: 'House Plans',
                                value: '${plans.length}',
                                icon: Icons.architecture,
                                color: AppColors.primary,
                                index: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedMetricCard(
                                title: 'Projects Done',
                                value: '${projects.length}',
                                icon: Icons.business,
                                color: AppColors.statusSuccess,
                                index: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedMetricCard(
                                title: 'Rating & Reviews',
                                value: reviews.isNotEmpty
                                    ? '${avgRating.toStringAsFixed(1)} ★'
                                    : '0.0 ★',
                                icon: Icons.star,
                                color: AppColors.starRating,
                                index: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Renders individual metric cards with entrance scale animation.
  Widget _buildAnimatedMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 120)),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds styled action buttons.
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    if (isFilled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, color: color, size: 18),
        label: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      );
    }
  }

  /// Renders booking request feed items with staggered slide-up and fade-in.
  Widget _buildAnimatedBookingRequestTile(
      BuildContext context, BookingModel booking, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 20),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 6,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.surfaceLight,
                        child: Icon(Icons.person,
                            size: 20, color: AppColors.secondary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary)),
                            Text(booking.userPhone,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: booking.status == 'Confirmed'
                              ? AppColors.statusSuccess.withValues(alpha: 0.12)
                              : AppColors.statusPending.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(booking.status,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: booking.status == 'Confirmed'
                                    ? AppColors.statusSuccess
                                    : AppColors.statusPending)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Plan: ${booking.planTitle}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text(
                      'Scheduled: ${booking.bookingDate} at ${booking.timeSlot}',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                  if (booking.notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Notes: "${booking.notes}"',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 12),
                  if (booking.status == 'Pending')
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await BookingService()
                                  .updateBookingStatus(booking.id, 'Cancelled');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Booking request declined.')));
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.statusDanger,
                              side: const BorderSide(
                                  color: AppColors.statusDanger),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Decline',
                                style: GoogleFonts.poppins(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await BookingService()
                                  .updateBookingStatus(booking.id, 'Confirmed');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Booking request confirmed!')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Accept & Confirm',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
