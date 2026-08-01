// import 'package:constructa/core/common/utils/bottom_navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../theme/palette.dart';
//
//
// class ProjectsScreen extends StatefulWidget {
//   const ProjectsScreen({super.key});
//
//   @override
//   State<ProjectsScreen> createState() => _ProjectsScreenState();
// }
//
// class _ProjectsScreenState extends State<ProjectsScreen> {
//   String _selectedTab = 'all';
//
//   final List<Map<String, dynamic>> _projects = [
//     {
//       'id': 'proj-1',
//       'title': 'Modern Minimalist Villa Extension',
//       'category': 'Home Renovation',
//       'status': 'In Progress',
//       'statusKey': 'in_progress',
//       'progress': 0.68,
//       'budgetSpent': '\$84,500',
//       'totalBudget': '\$120,000',
//       'contractor': 'Elena Rodriguez',
//       'contractorRole': 'Lead Architect & Builder',
//       'rating': 4.9,
//       'nextMilestone': 'Drywall & Custom Tiling (Due Oct 30)',
//       'imageUrl': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80',
//     },
//     {
//       'id': 'proj-2',
//       'title': 'Craftsman Bungalow Foundation',
//       'category': 'Outdoor & Addition',
//       'status': 'Planning',
//       'statusKey': 'planning',
//       'progress': 0.25,
//       'budgetSpent': '\$12,000',
//       'totalBudget': '\$48,000',
//       'contractor': 'Marcus Vance',
//       'contractorRole': 'Structural Engineer',
//       'rating': 4.8,
//       'nextMilestone': 'City Blueprint Approval & Permit',
//       'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=600&q=80',
//     },
//     {
//       'id': 'proj-3',
//       'title': 'Luxury Farmhouse Kitchen Overhaul',
//       'category': 'Interior Remodel',
//       'status': 'Completed',
//       'statusKey': 'completed',
//       'progress': 1.0,
//       'budgetSpent': '\$35,000',
//       'totalBudget': '\$35,000',
//       'contractor': 'David Miller',
//       'contractorRole': 'Master Carpenter',
//       'rating': 5.0,
//       'nextMilestone': 'Final Walkthrough Approved & Warranty Active',
//       'imageUrl': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=600&q=80',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final filtered = _projects.where((p) {
//       if (_selectedTab == 'all') return true;
//       return p['statusKey'] == _selectedTab;
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: ConstructaTheme.background,
//       appBar: AppBar(
//         backgroundColor: ConstructaTheme.background,
//         elevation: 0,
//         title: Row(
//           children: [
//             Icon(Icons.handyman_rounded, color: ConstructaTheme.primary),
//             const SizedBox(width: 8),
//             Text(
//               'Constructa',
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w800,
//                 color: ConstructaTheme.primary,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add_circle, color: ConstructaTheme.primary),
//             onPressed: () {},
//           ),
//           Padding(
//             padding:  EdgeInsets.only(right: 16.0),
//             child: CircleAvatar(
//               radius: 16,
//               backgroundColor: ConstructaTheme.primary,
//               child: Icon(Icons.person, size: 18, color: ConstructaTheme.onPrimary),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Projects & Renovations',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 color: ConstructaTheme.primary,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Track progress, monitor budgets, and collaborate with verified trades.',
//               style: GoogleFonts.roboto(
//                 fontSize: 13,
//                 color: ConstructaTheme.onSurfaceVariant,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildTab('all', 'All Projects (${_projects.length})'),
//                   _buildTab('in_progress', 'In Progress'),
//                   _buildTab('planning', 'Planning'),
//                   _buildTab('completed', 'Completed'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...filtered.map((proj) => _buildProjectCard(proj)),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const ConstructaBottomNavBar(currentIndex: 2),
//     );
//   }
//
//   Widget _buildTab(String key, String label) {
//     final isSelected = _selectedTab == key;
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: ChoiceChip(
//         label: Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? ConstructaTheme.onPrimary : ConstructaTheme.onSurfaceVariant,
//           ),
//         ),
//         selected: isSelected,
//         selectedColor: ConstructaTheme.primary,
//         backgroundColor: ConstructaTheme.surface,
//         onSelected: (_) => setState(() => _selectedTab = key),
//       ),
//     );
//   }
//
//   Widget _buildProjectCard(Map<String, dynamic> proj) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       color: ConstructaTheme.surface,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: ConstructaTheme.outlineVariant),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Image.network(
//                   proj['imageUrl'],
//                   height: 160,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: ConstructaTheme.primary,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     proj['status'],
//                     style: GoogleFonts.poppins(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: ConstructaTheme.onPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: ConstructaTheme.surface,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.star, size: 14, color: ConstructaTheme.ratingStar),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${proj['rating']}',
//                         style: GoogleFonts.poppins(
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           color: ConstructaTheme.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   proj['title'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: ConstructaTheme.primary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 LinearProgressIndicator(
//                   value: proj['progress'],
//                   backgroundColor: ConstructaTheme.surfaceContainerLow,
//                   color: ConstructaTheme.primary,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Budget Spent:',
//                       style: GoogleFonts.roboto(fontSize: 12, color: ConstructaTheme.onSurfaceVariant),
//                     ),
//                     Text(
//                       '${proj['budgetSpent']} / ${proj['totalBudget']}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: ConstructaTheme.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
