import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/booking_service.dart';
import 'add_edit_house_plan_screen.dart';
import 'add_edit_project_screen.dart';
import 'company_profile_screen.dart';

class ConstructorDashboardScreen extends StatelessWidget {
  const ConstructorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? 'comp_1';

    return StreamBuilder<UserModel?>(
      stream: AuthService().getUserData(),
      builder: (context, userSnap) {
        final companyUser = userSnap.data;
        final companyName = companyUser?.fullName.isNotEmpty == true ? companyUser!.fullName : 'BuildWell Constructions';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Constructor Console', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text(companyName, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note, color: AppColors.secondary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CompanyProfileScreen()),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics Overview Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Active Bookings',
                        value: '4',
                        icon: Icons.assignment_turned_in,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'House Plans',
                        value: '6',
                        icon: Icons.architecture,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Completed Projects',
                        value: '18',
                        icon: Icons.business,
                        color: AppColors.statusSuccess,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Rating & Reviews',
                        value: '4.9 ★',
                        icon: Icons.star,
                        color: AppColors.starRating,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Management Actions
                Text('Quick Management Actions', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddEditHousePlanScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add_home_work, color: Colors.white, size: 18),
                        label: Text('Add House Plan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddEditProjectScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.secondary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.secondary, size: 18),
                        label: Text('Add Project', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Incoming Booking Requests Feed
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Incoming Booking Requests', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Real-time', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.statusSuccess, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),

                StreamBuilder<List<BookingModel>>(
                  stream: BookingService().getCompanyBookings(companyUid),
                  builder: (context, bookingSnap) {
                    if (bookingSnap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final bookings = bookingSnap.data ?? [];
                    if (bookings.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('No booking requests received yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                        ),
                      );
                    }

                    return Column(
                      children: bookings.map((b) => _buildBookingRequestTile(context, b)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBookingRequestTile(BuildContext context, BookingModel booking) {
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
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person, size: 20, color: AppColors.secondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                    Text(booking.userPhone, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: booking.status == 'Confirmed' ? AppColors.statusSuccess.withOpacity(0.12) : AppColors.statusPending.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(booking.status, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: booking.status == 'Confirmed' ? AppColors.statusSuccess : AppColors.statusPending)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Plan: ${booking.planTitle}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text('Requested Date: ${booking.bookingDate} at ${booking.timeSlot}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Notes: "${booking.notes}"', style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 12),

          if (booking.status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await BookingService().updateBookingStatus(booking.id, 'Cancelled');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking request declined.')));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusDanger,
                      side: const BorderSide(color: AppColors.statusDanger),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Decline', style: GoogleFonts.poppins(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await BookingService().updateBookingStatus(booking.id, 'Confirmed');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking request confirmed!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Accept & Confirm', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
