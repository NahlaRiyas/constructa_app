import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/admin_users_screen.dart';
import '../screens/admin_companies_screen.dart';
import '../screens/admin_bookings_screen.dart';
import '../screens/admin_reviews_screen.dart';
import '../screens/admin_house_plans_screen.dart';
import '../screens/admin_projects_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  final List<String> _navLabels = [
    'Dashboard',
    'Users',
    'Companies',
    'Bookings',
    'Reviews',
    'House Plans',
    'Projects',
  ];

  final List<IconData> _navIcons = [
    Icons.dashboard_outlined,
    Icons.people_outline,
    Icons.business_center_outlined,
    Icons.calendar_month_outlined,
    Icons.star_outline,
    Icons.architecture_outlined,
    Icons.work_outline,
  ];

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen();
      case 1:
        return const AdminUsersScreen();
      case 2:
        return const AdminCompaniesScreen();
      case 3:
        return const AdminBookingsScreen();
      case 4:
        return const AdminReviewsScreen();
      case 5:
        return const AdminHousePlansScreen();
      case 6:
        return const AdminProjectsScreen();
      default:
        return const AdminDashboardScreen();
    }
  }

  Widget _buildSidebarContent({bool isDrawer = false}) {
    return Container(
      width: isDrawer ? null : 260,
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        border: Border(right: BorderSide(color: AppColors.surfaceDark)),
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.construction, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CONSTRUCTA', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Admin Panel', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.surfaceDark, height: 1),
          const SizedBox(height: 12),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _navLabels.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        if (isDrawer) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _navIcons[index],
                              color: isSelected ? AppColors.secondaryContainer : AppColors.textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _navLabels[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Text('Constructa Admin v1.0', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          title: Text(
            'Admin - ${_navLabels[_selectedIndex]}',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.darkBackground,
          child: SafeArea(child: _buildSidebarContent(isDrawer: true)),
        ),
        body: _buildCurrentScreen(),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          _buildSidebarContent(isDrawer: false),

          // Main Content Area
          Expanded(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }
}
