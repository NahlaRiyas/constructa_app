// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../theme/palette.dart';
// import '../utils/global.dart';
//
//
// class BookingsScreen extends StatelessWidget {
//   const BookingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize MediaQuery metrics
//     initScreenSize(context);
//
//     final double horizontalPadding = w * 0.05;
//     final double titleFontSize = w * 0.045;
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.cardBackground,
//         elevation: 0,
//         title: Text(
//           'My Bookings',
//           style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: height * 0.02),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Active Consultations & Site Visits',
//               style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//             ),
//             SizedBox(height: height * 0.015),
//
//             // Booking Item 1
//             _buildBookingCard(
//               context,
//               companyName: 'BuildWell Constructions',
//               planName: 'Modern Villa Plan (3BHK)',
//               date: 'August 5, 2026 at 10:00 AM',
//               status: 'Confirmed',
//               statusColor: AppColors.statusSuccess,
//             ),
//             SizedBox(height: height * 0.0175),
//
//             // Booking Item 2
//             _buildBookingCard(
//               context,
//               companyName: 'Apex Architects',
//               planName: 'Duplex Smart House',
//               date: 'August 12, 2026 at 02:30 PM',
//               status: 'Pending Review',
//               statusColor: AppColors.statusPending,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBookingCard(
//       BuildContext context, {
//         required String companyName,
//         required String planName,
//         required String date,
//         required String status,
//         required Color statusColor,
//       }) {
//     return Container(
//       padding: EdgeInsets.all(w * 0.04),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.borderLight),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   companyName,
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w * 0.0375, color: AppColors.textPrimary),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: height * 0.005),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   status,
//                   style: GoogleFonts.poppins(fontSize: w * 0.027, fontWeight: FontWeight.bold, color: statusColor),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.01),
//           Text(
//             planName,
//             style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.textSecondary),
//           ),
//           SizedBox(height: height * 0.015),
//           Row(
//             children: [
//               Icon(Icons.calendar_month, size: w * 0.04, color: AppColors.primary),
//               SizedBox(width: w * 0.015),
//               Text(
//                 date,
//                 style: GoogleFonts.poppins(fontSize: w * 0.03, color: AppColors.textPrimary),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.0175),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     side: const BorderSide(color: AppColors.borderLight),
//                   ),
//                   child: Text('Reschedule', style: GoogleFonts.poppins(fontSize: w * 0.03, color: AppColors.textPrimary)),
//                 ),
//               ),
//               SizedBox(width: w * 0.025),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: Text('Chat Builder', style: GoogleFonts.poppins(fontSize: w * 0.03, color: AppColors.textLight, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
