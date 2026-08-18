// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../theme/palette.dart';
// import '../utils/global.dart';
//
// class CompaniesScreen extends StatelessWidget {
//   const CompaniesScreen({super.key});
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
//           'Companies Directory',
//           style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: AppColors.textSecondary),
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
//                 hintText: 'Search by company name, city or specialty...',
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
//             // Verified Builders Label
//             Text(
//               'Verified Builders & Contractors',
//               style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//             ),
//              SizedBox(height: height*0.02),
//
//             // Company Card Item 1
//             _buildCompanyCard(
//               context,
//               name: 'BuildWell Constructions',
//               specialty: 'Residential & Villa Design',
//               rating: '4.9',
//               reviews: '124',
//               location: 'Kochi, Kerala',
//               imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQ1kXvkCTl9yw-Qrb-Ol27v1ConvBkc71WuHPWDfnLlYFMa0AZ_2733EiBV98BVYgSO2dXIYJDBj1uQL-rTYE0Zudt2dkSO_23XRGys8sOk5c8kllrHyFsPEIqGHNKNgsGG9c-Fq99dKciehGfXqO7KOlchpEYXf3kvXxmYbWOphH8IKxGBDzolCAn6zkWAe1WbzRtqZZnL7VHe5klHCVSYPaESrzB5DIuZqLaon5q1nDORm1fYPL',
//             ),
//              SizedBox(height: height*0.02),
//
//             // Company Card Item 2
//             _buildCompanyCard(
//               context,
//               name: 'Apex Architects & Engineers',
//               specialty: 'Commercial & Multi-story',
//               rating: '4.8',
//               reviews: '98',
//               location: 'Trivandrum, Kerala',
//               imageUrl: 'https://images.jdmagicbox.com/comp/rajahmundry/k7/9999px883.x883.120421104741.d6k7/catalogue/apex-architects-and-engineers-danavaipeta-rajahmundry-architects-jrz17zfngj.jpg',
//             ),
//             SizedBox(height: height*0.02),
//
//             // Company Card Item 3
//             _buildCompanyCard(
//               context,
//               name: 'GreenHome Sustainable Tech',
//               specialty: 'Eco-Friendly & Smart Homes',
//               rating: '4.7',
//               reviews: '86',
//               location: 'Calicut, Kerala',
//               imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&auto=format&fit=crop&q=60',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCompanyCard(
//       BuildContext context, {
//         required String name,
//         required String specialty,
//         required String rating,
//         required String reviews,
//         required String location,
//         required String imageUrl,
//       }) {
//     final double cardImageSize = w * 0.2;
//
//     return Container(
//       padding: EdgeInsets.all(w * 0.035),
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
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               imageUrl,
//               width: cardImageSize,
//               height: cardImageSize,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(width: w * 0.03),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w * 0.035, color: AppColors.textPrimary),
//                 ),
//                 SizedBox(height: height * 0.0025),
//                 Text(
//                   specialty,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.poppins(fontSize: w * 0.027, color: AppColors.textSecondary),
//                 ),
//                 SizedBox(height: height * 0.005),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: w * 0.035),
//                     SizedBox(width: w * 0.01),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: GoogleFonts.poppins(fontSize: w * 0.027, color: AppColors.textSecondary),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: height * 0.0075),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: AppColors.starRating, size: w * 0.0375),
//                     Text(' $rating ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: w * 0.03, color: AppColors.textPrimary)),
//                     Flexible(
//                       child: Text(
//                         '($reviews reviews)',
//                         style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: w * 0.027),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.chevron_right, color: AppColors.primary),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
