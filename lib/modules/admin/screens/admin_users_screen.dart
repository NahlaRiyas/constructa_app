import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/admin_service.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manage Users', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('View and manage all registered users', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            StreamBuilder<List<UserModel>>(
              stream: AdminService().getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error loading users: ${snapshot.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                    ),
                  );
                }
                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text('No users found.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 700,
                    child: _buildUsersTable(context, users),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTable(BuildContext context, List<UserModel> users) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Name', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(flex: 2, child: Text('Email', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Role', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Phone', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 80),
              ],
            ),
          ),
          // Table Rows
          ...users.map((user) => _buildUserRow(context, user)),
        ],
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, UserModel user) {
    final roleColor = user.role == 'company' ? AppColors.secondary : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.surfaceLight,
                  backgroundImage: user.profileImageUrl.isNotEmpty ? NetworkImage(user.profileImageUrl) : null,
                  child: user.profileImageUrl.isEmpty ? const Icon(Icons.person, size: 18, color: AppColors.textMuted) : null,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(user.fullName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(user.email, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(user.role.toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: roleColor)),
            ),
          ),
          Expanded(
            child: Text(user.phoneNumber.isNotEmpty ? user.phoneNumber : '-', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ),
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusDanger),
              onPressed: () => _confirmDelete(context, user),
              tooltip: 'Delete User',
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete User', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${user.fullName}"? This action cannot be undone.', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              await AdminService().deleteUser(user.uid);
              if (context.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User "${user.fullName}" deleted.')));
              }
            },
            child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.statusDanger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
