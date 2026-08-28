import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/admin_service.dart';

class AdminProjectsScreen extends StatelessWidget {
  const AdminProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage Projects', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('View and manage all completed projects across the platform', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            StreamBuilder<List<ProjectModel>>(
              stream: AdminService().getAllProjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error loading projects: ${snapshot.error}', style: GoogleFonts.poppins(color: AppColors.statusDanger)),
                    ),
                  );
                }
                final projects = snapshot.data ?? [];
                if (projects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text('No projects found.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 750,
                    child: _buildProjectsTable(context, projects),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsTable(BuildContext context, List<ProjectModel> projects) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Project Title', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Company', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Category', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Location', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Completed', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 50),
              ],
            ),
          ),
          ...projects.map((project) => _buildProjectRow(context, project)),
        ],
      ),
    );
  }

  Widget _buildProjectRow(BuildContext context, ProjectModel project) {
    Color catColor = AppColors.primary;
    if (project.category == 'Renovation') catColor = AppColors.secondary;
    if (project.category == 'Interior') catColor = AppColors.accentPurple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(project.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(project.companyName, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(project.category, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: catColor)),
            ),
          ),
          Expanded(
            child: Text(project.location, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(project.completionDate.isNotEmpty ? project.completionDate : '-', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ),
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusDanger),
              onPressed: () => _confirmDelete(context, project),
              tooltip: 'Delete Project',
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Project', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${project.title}"?', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              await AdminService().deleteProject(project.id);
              if (context.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project "${project.title}" deleted.')));
              }
            },
            child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.statusDanger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
