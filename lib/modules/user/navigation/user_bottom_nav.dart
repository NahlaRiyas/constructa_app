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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          border: Border(
            top: BorderSide(color: AppColors.getBorderLight(context), width: 1.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          indicatorColor: AppColors.getSurfaceLight(context),
          backgroundColor: AppColors.getCardBackground(context),
          elevation: 0,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.business_center_outlined),
              selectedIcon: Icon(Icons.business_center, color: AppColors.primary),
              label: 'Companies',
            ),
            const NavigationDestination(
              icon: Icon(Icons.event_available_outlined),
              selectedIcon: Icon(Icons.event_available, color: AppColors.primary),
              label: 'Bookings',
            ),
            const NavigationDestination(
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
