import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../utils/global.dart';


class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery metrics
    initScreenSize(context);

    final double horizontalPadding = w > 400 ? 20.0 : 14.0;
    final double titleFontSize = w > 360 ? 18.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Consultations & Site Visits',
              style: GoogleFonts.poppins(fontSize: w > 360 ? 16 : 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            // Booking Item 1
            _buildBookingCard(
              context,
              companyName: 'BuildWell Constructions',
              planName: 'Modern Villa Plan (3BHK)',
              date: 'August 5, 2026 at 10:00 AM',
              status: 'Confirmed',
              statusColor: AppColors.statusSuccess,
            ),
            const SizedBox(height: 14),

            // Booking Item 2
            _buildBookingCard(
              context,
              companyName: 'Apex Architects',
              planName: 'Duplex Smart House',
              date: 'August 12, 2026 at 02:30 PM',
              status: 'Pending Review',
              statusColor: AppColors.statusPending,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(
      BuildContext context, {
        required String companyName,
        required String planName,
        required String date,
        required String status,
        required Color statusColor,
      }) {
    return Container(
      padding: EdgeInsets.all(w > 360 ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
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
                  companyName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w > 360 ? 15 : 13, color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            planName,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                date,
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  child: Text('Reschedule', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Chat Builder', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
