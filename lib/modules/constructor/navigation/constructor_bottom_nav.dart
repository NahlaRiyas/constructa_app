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
  State<ConstructorMainNavigationShell> createState() =>
      _ConstructorMainNavigationShellState();
}

class _ConstructorMainNavigationShellState
    extends State<ConstructorMainNavigationShell> {
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
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.secondary),
              label: 'Dashboard',
            ),
            const NavigationDestination(
              icon: Icon(Icons.architecture_outlined),
              selectedIcon:
                  Icon(Icons.architecture, color: AppColors.secondary),
              label: 'Plans',
            ),
            const NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment, color: AppColors.secondary),
              label: 'Bookings',
            ),
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: AppColors.secondary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
