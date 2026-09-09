import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/admin_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard Overview', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Manage your platform data and operations', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Metric Cards
            _buildMetricsGrid(),
            const SizedBox(height: 32),

            // Recent Activity
            Text('Recent Bookings', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildRecentBookings(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final adminService = AdminService();
    return StreamBuilder<List<UserModel>>(
      stream: adminService.getAllUsers(),
      builder: (context, userSnap) {
        if (userSnap.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error loading users: ${userSnap.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
          );
        }
        final users = userSnap.data ?? [];
        return StreamBuilder<List<CompanyModel>>(
          stream: adminService.getAllCompanies(),
          builder: (context, companySnap) {
            if (companySnap.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading companies: ${companySnap.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
              );
            }
            final companies = companySnap.data ?? [];
            return StreamBuilder<List<BookingModel>>(
              stream: adminService.getAllBookings(),
              builder: (context, bookingSnap) {
                if (bookingSnap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading bookings: ${bookingSnap.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                  );
                }
                final bookings = bookingSnap.data ?? [];
                return StreamBuilder<List<ReviewModel>>(
                  stream: adminService.getAllReviews(),
                  builder: (context, reviewSnap) {
                    if (reviewSnap.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error loading reviews: ${reviewSnap.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                      );
                    }
                    final reviews = reviewSnap.data ?? [];
                    final pendingBookings = bookings.where((b) => b.status == 'Pending').length;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 480 ? 2 : 1);
                        final childAspectRatio = constraints.maxWidth > 800 ? 2.2 : (constraints.maxWidth > 480 ? 2.2 : 2.6);
                        return GridView.count(
                          crossAxisCount: crossCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                          children: [
                            _buildMetricCard('Total Users', '${users.length}', Icons.people, AppColors.primary),
                            _buildMetricCard('Total Companies', '${companies.length}', Icons.business, AppColors.secondary),
                            _buildMetricCard('Total Bookings', '${bookings.length}', Icons.calendar_month, AppColors.accentPurple),
                            _buildMetricCard('Pending Bookings', '$pendingBookings', Icons.pending_actions, AppColors.statusPending),
                            _buildMetricCard('Total Reviews', '${reviews.length}', Icons.star, AppColors.starRating),
                            _buildMetricCard('Verified Companies', '${companies.where((c) => c.isVerified).length}', Icons.verified, AppColors.statusSuccess),
                            _buildMetricCard('Active Users', '${users.where((u) => u.role == 'customer').length}', Icons.person, AppColors.accentSky),
                            _buildMetricCard('Contractors', '${users.where((u) => u.role == 'company').length}', Icons.engineering, AppColors.tertiary),
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
      },
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookings() {
    return StreamBuilder<List<BookingModel>>(
      stream: AdminService().getAllBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Error loading recent bookings: ${snapshot.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
            ),
          );
        }
        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text('No bookings yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
          );
        }

        final recent = bookings.take(5).toList();
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: recent.map((b) => _buildBookingRow(b)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBookingRow(BookingModel booking) {
    Color statusColor = AppColors.statusPending;
    if (booking.status == 'Confirmed') statusColor = AppColors.statusSuccess;
    if (booking.status == 'Completed') statusColor = AppColors.primary;
    if (booking.status == 'Cancelled') statusColor = AppColors.statusDanger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration:  BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.userName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(booking.companyName, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: Text(booking.planTitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(booking.bookingDate, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(booking.status, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }
}
