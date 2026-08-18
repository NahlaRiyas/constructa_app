// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../theme/palette.dart';
// import '../../models/user_model.dart';
// import '../../services/auth_service.dart';
// import '../utils/global.dart';
//
// class CustomerDashboardScreen extends StatelessWidget {
//   const CustomerDashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize global w and height via MediaQuery
//     initScreenSize(context);
//
//     // Dynamic responsive dimensions using MediaQuery
//     final double horizontalPadding = w * 0.05;
//     final double headerFontSize = w * 0.045;
//     final double cardImageSize = w * 0.2;
//
//     return StreamBuilder<UserModel?>(
//       stream: AuthService().getUserData(),
//       builder: (context, snapshot) {
//         final user = snapshot.data;
//         final displayName = user?.fullName.split(' ').first ?? 'User';
//
//         return Scaffold(
//           backgroundColor: AppColors.background,
//           appBar: AppBar(
//             backgroundColor: AppColors.cardBackground,
//             elevation: 0,
//             title: Row(
//               children: [
//                 CircleAvatar(
//                   radius: w * 0.045,
//                   backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD81MQIAtwCAvaToAvn-xAbD9vnTsjstD3VK49OjJPOeutnV9xNW7Je9xGKfYK_eppzMTCWDi2YI5DfJaJpFPs705YpWiM2l7Tw3JIRcCB54Y3Gw3w9ARJCdG_7WzD0pCczukdDur2WYNHBZODtStWM_iNTXgiV0-phK4C2aHjt_GYbJgruFNKzbzu2tyUsQBQA3nJfMcvOO6CIjVpM8HJfKmGA-DT9rcNT0RQCCOF0iIuLHMqsG3rS'),
//                 ),
//                 SizedBox(width: w * 0.025),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Good Morning,', style: GoogleFonts.poppins(fontSize: w * 0.027, color: AppColors.textSecondary)),
//                     Text(displayName, style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
//                   ],
//                 ),
//               ],
//             ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: height * 0.02),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Responsive Search Bar
//             TextField(
//               style: GoogleFonts.poppins(fontSize: w * 0.032, color: AppColors.textPrimary),
//               decoration: InputDecoration(
//                 hintText: 'Search contractors, plans, or services...',
//                 hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: w * 0.032),
//                 prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
//                 filled: true,
//                 fillColor: AppColors.cardBackground,
//                 contentPadding: EdgeInsets.symmetric(vertical: height * 0.0175, horizontal: w * 0.04),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.borderLight),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.borderLight),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//                 ),
//               ),
//             ),
//             SizedBox(height: height * 0.02),
//
//             // Responsive Filter Chips
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   FilterChip(
//                     selected: true,
//                     label: Text('Construction', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: w * 0.027, fontWeight: FontWeight.bold)),
//                     onSelected: (val) {},
//                     selectedColor: AppColors.primary,
//                     avatar: const Icon(Icons.construction, color: AppColors.textLight, size: 16),
//                   ),
//                   SizedBox(width: w * 0.02),
//                   FilterChip(
//                     label: Text('Renovation', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: w * 0.027)),
//                     onSelected: (val) {},
//                     backgroundColor: AppColors.cardBackground,
//                   ),
//                   SizedBox(width: w * 0.02),
//                   FilterChip(
//                     label: Text('Interior', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: w * 0.027)),
//                     onSelected: (val) {},
//                     backgroundColor: AppColors.cardBackground,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: height * 0.025),
//
//             // Responsive Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Top Rated Companies', style: GoogleFonts.poppins(fontSize: headerFontSize, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text('View All', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: w * 0.03)),
//                 ),
//               ],
//             ),
//             SizedBox(height: height * 0.01),
//
//             // Responsive Card
//             Card(
//               color: AppColors.cardBackground,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 side: const BorderSide(color: AppColors.borderLight),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(w * 0.035),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
//                         width: cardImageSize,
//                         height: cardImageSize,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: w * 0.03),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('BuildWell Constructions', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w * 0.0375, color: AppColors.textPrimary)),
//                           SizedBox(height: height * 0.005),
//                           Row(
//                             children: [
//                               const Icon(Icons.star, color: AppColors.starRating, size: 16),
//                               Text(' 4.9 ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w * 0.032, color: AppColors.textPrimary)),
//                               Text('(124 reviews)', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: w * 0.03)),
//                             ],
//                           ),
//                           SizedBox(height: height * 0.005),
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
//                               Text(' Kochi, Kerala', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: w * 0.03)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {},
//       //   backgroundColor: AppColors.primary,
//       //   child: const Icon(Icons.add, color: AppColors.textLight),
//       // ),
//         );
//       },
//     );
//   }
// }
