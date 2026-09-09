import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/booking_service.dart';
import 'rate_review_screen.dart';

/// UserBookingsScreen
///
/// Customer appointments, site visits, and consultation management screen.
/// Employs MediaQuery throughout for responsive card sizing, padding, and font scaling.
class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // MediaQuery Responsive Layout Sizing
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double vPadding = (h * 0.018).clamp(10.0, 20.0);
    final double appBarTitleFontSize = (w * 0.045).clamp(16.0, 22.0);
    final double sectionHeaderFontSize = (w * 0.04).clamp(14.0, 18.0);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardBackground(context),
        elevation: 0,
        title: Text(
          'My Bookings',
          style: GoogleFonts.poppins(
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Consultations & Site Visits',
              style: GoogleFonts.poppins(
                fontSize: sectionHeaderFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            SizedBox(height: h * 0.015),

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
                      padding: EdgeInsets.symmetric(vertical: h * 0.06),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: (w * 0.12).clamp(36.0, 60.0), color: AppColors.textMuted),
                          SizedBox(height: h * 0.01),
                          Text(
                            'No active bookings yet.',
                            style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context), fontSize: (w * 0.035).clamp(12.0, 16.0)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: bookings.asMap().entries.map((entry) {
                    final index = entry.key;
                    final booking = entry.value;
                    return _buildAnimatedBookingCard(context, booking, index, w, h);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Renders booking card with entrance slide and fade animation using MediaQuery dimensions.
  Widget _buildAnimatedBookingCard(
      BuildContext context, BookingModel booking, int index, double w, double h) {
    Color statusColor = AppColors.statusPending;
    if (booking.status == 'Confirmed') statusColor = AppColors.statusSuccess;
    if (booking.status == 'Completed') statusColor = AppColors.primary;
    if (booking.status == 'Cancelled') statusColor = AppColors.statusDanger;

    final double titleFontSize = (w * 0.038).clamp(13.0, 17.0);
    final double subtitleFontSize = (w * 0.032).clamp(11.0, 14.0);
    final double captionFontSize = (w * 0.028).clamp(10.0, 12.0);
    final double borderRadius = (w * 0.04).clamp(12.0, 18.0);
    final double buttonHeight = (h * 0.052).clamp(38.0, 48.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 20),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: h * 0.018),
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: AppColors.getBorderLight(context)),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
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
                          booking.companyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(w * 0.05),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: captionFontSize,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.008),
                  Text(
                    booking.planTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                  SizedBox(height: h * 0.012),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: (w * 0.04).clamp(14.0, 18.0), color: AppColors.primary),
                      SizedBox(width: w * 0.015),
                      Expanded(
                        child: Text(
                          '${booking.bookingDate} at ${booking.timeSlot}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.w500,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (booking.notes.isNotEmpty) ...[
                    SizedBox(height: h * 0.008),
                    Text(
                      'Notes: "${booking.notes}"',
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontStyle: FontStyle.italic,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                  SizedBox(height: h * 0.018),
                  Row(
                    children: [
                      if (booking.userPhone.isNotEmpty) ...[
                        Expanded(
                          child: SizedBox(
                            height: buttonHeight,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse('tel:${booking.userPhone}');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not launch phone dialer.')),
                                    );
                                  }
                                }
                              },
                              icon: Icon(Icons.phone, size: (w * 0.04).clamp(14.0, 18.0)),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.025)),
                                side: BorderSide(color: AppColors.getBorderLight(context)),
                              ),
                              label: Text(
                                'Contact',
                                style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: AppColors.getTextPrimary(context)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.025),
                      ],
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (booking.status == 'Completed') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RateReviewScreen(
                                      companyId: booking.companyId,
                                      companyName: booking.companyName,
                                      targetId: booking.companyId,
                                      targetType: 'company',
                                      targetTitle: booking.companyName,
                                    ),
                                  ),
                                );
                              } else if (booking.status == 'Pending' || booking.status == 'Confirmed') {
                                _showCancelBookingDialog(context, booking);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: booking.status == 'Completed' ? AppColors.primary : AppColors.statusDanger,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.025)),
                            ),
                            child: Text(
                              booking.status == 'Completed' ? 'Rate Service' : 'Cancel Booking',
                              style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
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

  void _showCancelBookingDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to cancel your booking with ${booking.companyName} for ${booking.planTitle}?',
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.getTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Booking', style: GoogleFonts.poppins(color: AppColors.getTextSecondary(context))),
          ),
          TextButton(
            onPressed: () async {
              await BookingService().updateBookingStatus(booking.id, 'Cancelled');
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking cancelled successfully.')),
                );
              }
            },
            child: Text(
              'Cancel Booking',
              style: GoogleFonts.poppins(color: AppColors.statusDanger, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
