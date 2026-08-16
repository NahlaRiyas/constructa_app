import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/booking_service.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  String _selectedStatus = 'All';
  final List<String> _statusFilters = ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? 'comp_1';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'Customer Bookings Console',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: AppColors.cardBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusFilters.map((st) {
                  final isSelected = _selectedStatus == st;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(st, style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 12)),
                      selectedColor: AppColors.secondary,
                      backgroundColor: AppColors.surfaceLight,
                      onSelected: (val) => setState(() => _selectedStatus = st),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Bookings List Stream
          Expanded(
            child: StreamBuilder<List<BookingModel>>(
              stream: BookingService().getCompanyBookings(companyUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var bookings = snapshot.data ?? [];
                if (_selectedStatus != 'All') {
                  bookings = bookings.where((b) => b.status.toLowerCase() == _selectedStatus.toLowerCase()).toList();
                }

                if (bookings.isEmpty) {
                  return Center(
                    child: Text('No bookings found under "$_selectedStatus".', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final b = bookings[index];
                    return _buildBookingControlCard(context, b);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingControlCard(BuildContext context, BookingModel booking) {
    Color statusColor = AppColors.statusPending;
    if (booking.status == 'Confirmed') statusColor = AppColors.statusSuccess;
    if (booking.status == 'Completed') statusColor = AppColors.primary;
    if (booking.status == 'Cancelled') statusColor = AppColors.statusDanger;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(booking.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(booking.status.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(booking.userPhone, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Plan: ${booking.planTitle}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text('Scheduled: ${booking.bookingDate} at ${booking.timeSlot}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Client Request: "${booking.notes}"', style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 12),

          // Status Action Controls
          Row(
            children: [
              if (booking.status == 'Pending') ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await BookingService().updateBookingStatus(booking.id, 'Confirmed');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking confirmed.')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusSuccess, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text('Confirm', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              if (booking.status == 'Confirmed') ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await BookingService().updateBookingStatus(booking.id, 'Completed');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking marked as Completed!')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text('Mark Completed', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              if (booking.status != 'Cancelled' && booking.status != 'Completed')
                OutlinedButton(
                  onPressed: () async {
                    await BookingService().updateBookingStatus(booking.id, 'Cancelled');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking cancelled.')));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.statusDanger,
                    side: const BorderSide(color: AppColors.statusDanger),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
