import 'package:flutter/material.dart';
import '../../../theme/palette.dart';
import '../../../core/common/utils/global.dart';
import '../screens/constructor_dashboard_screen.dart';
import '../screens/manage_house_plans_screen.dart';
import '../screens/manage_bookings_screen.dart';
import '../screens/constructor_profile_screen.dart';

class ConstructorMainNavigationShell extends StatefulWidget {
  final int initialIndex;
  const ConstructorMainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<ConstructorMainNavigationShell> createState() => _ConstructorMainNavigationShellState();
}

class _ConstructorMainNavigationShellState extends State<ConstructorMainNavigationShell> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    ConstructorDashboardScreen(),
    ManageHousePlansScreen(),
    ManageBookingsScreen(),
    ConstructorProfileScreen(),
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
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.secondary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.architecture_outlined),
              selectedIcon: Icon(Icons.architecture, color: AppColors.secondary),
              label: 'Plans & Projects',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment, color: AppColors.secondary),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: AppColors.secondary),
              label: 'Company Profile',
            ),
          ],
        ),
      ),
    );
  }
}
