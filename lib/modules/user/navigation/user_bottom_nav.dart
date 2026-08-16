import 'package:flutter/material.dart';
import '../../../theme/palette.dart';
import '../../../core/common/utils/global.dart';
import '../screens/user_home_screen.dart';
import '../screens/user_companies_screen.dart';
import '../screens/user_bookings_screen.dart';
import '../screens/user_profile_screen.dart';

class UserMainNavigationShell extends StatefulWidget {
  final int initialIndex;
  const UserMainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<UserMainNavigationShell> createState() => _UserMainNavigationShellState();
}

class _UserMainNavigationShellState extends State<UserMainNavigationShell> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    UserHomeScreen(),
    UserCompaniesScreen(),
    UserBookingsScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 1.0),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          indicatorColor: AppColors.surfaceLight,
          backgroundColor: AppColors.cardBackground,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.business_center_outlined),
              selectedIcon: Icon(Icons.business_center, color: AppColors.primary),
              label: 'Companies',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_available_outlined),
              selectedIcon: Icon(Icons.event_available, color: AppColors.primary),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
