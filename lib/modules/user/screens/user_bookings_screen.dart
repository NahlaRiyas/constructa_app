import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/booking_service.dart';
import 'rate_project_screen.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Consultations & Site Visits',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),

            StreamBuilder<List<BookingModel>>(
              stream: BookingService().getUserBookings(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bookings = snapshot.data ?? [];
                if (bookings.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 8),
                          Text('No active bookings yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: bookings.map((b) => _buildBookingCard(context, b)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    Color statusColor = AppColors.statusPending;
    if (booking.status == 'Confirmed') statusColor = AppColors.statusSuccess;
    if (booking.status == 'Completed') statusColor = AppColors.primary;
    if (booking.status == 'Cancelled') statusColor = AppColors.statusDanger;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.companyName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking.planTitle,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                '${booking.bookingDate} at ${booking.timeSlot}',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
            ],
          ),
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Notes: "${booking.notes}"', style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact feature: Calling contractor...')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  child: Text('Contact Builder', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (booking.status == 'Completed') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RateProjectScreen(companyId: booking.companyId, companyName: booking.companyName),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reschedule request sent.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    booking.status == 'Completed' ? 'Rate Service' : 'Reschedule',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
