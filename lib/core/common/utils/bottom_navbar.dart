// import 'package:flutter/material.dart';
// import '../../../theme/palette.dart';
//
// import '../navigation_screens/booking_screen.dart';
// import '../navigation_screens/company_screen.dart';
// import '../navigation_screens/home_screen.dart';
// import '../navigation_screens/profile_screen.dart';
// import 'global.dart';
//
//
// /// Reusable Standalone Bottom Navigation Bar Component
// /// Easily access and connect pages through this dedicated navigation page
// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.cardBackground,
//         border: Border(
//           top: BorderSide(color: AppColors.borderLight, width: 1.0),
//         ),
//       ),
//       child: NavigationBar(
//         selectedIndex: currentIndex,
//         onDestinationSelected: onTap,
//         indicatorColor: AppColors.surfaceLight,
//         backgroundColor: AppColors.cardBackground,
//         elevation: 0,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home, color: AppColors.primary),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.business_center_outlined),
//             selectedIcon: Icon(Icons.business_center, color: AppColors.primary),
//             label: 'Companies',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.event_available_outlined),
//             selectedIcon: Icon(Icons.event_available, color: AppColors.primary),
//             label: 'Bookings',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person, color: AppColors.primary),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Dedicated Navigation Shell connecting primary application screens
// class MainNavigationShell extends StatefulWidget {
//   final int initialIndex;
//   const MainNavigationShell({super.key, this.initialIndex = 0});
//
//   @override
//   State<MainNavigationShell> createState() => _MainNavigationShellState();
// }
//
// class _MainNavigationShellState extends State<MainNavigationShell> {
//   late int _selectedIndex;
//
//   // Connected screens routed via CustomBottomNavBar
//   final List<Widget> _screens = const [
//     CustomerDashboardScreen(),
//     CompaniesScreen(),
//     BookingsScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     initScreenSize(context);
//
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
