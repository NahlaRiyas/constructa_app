import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';

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
            Text('Inspect, review all project designs/images, and manage platform listings', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
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
                    width: 850,
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
            decoration:  BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                 SizedBox(width: 60, child: Text('Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: Text('Project Title', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Company', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Category', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Location', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                Expanded(child: Text('Completed', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                const SizedBox(width: 90),
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

    return InkWell(
      onTap: () => _showProjectDetailsDialog(context, project),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration:  BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
        ),
        child: Row(
          children: [
            // Thumbnail with count badge
            SizedBox(
              width: 60,
              height: 46,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: project.imageUrls.isNotEmpty
                        ? Image.network(
                            project.imageUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceLight, child: const Icon(Icons.broken_image, size: 20)),
                          )
                        : Container(color: AppColors.surfaceLight, child: const Icon(Icons.business, size: 20, color: AppColors.secondary)),
                  ),
                  if (project.imageUrls.length > 1)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${project.imageUrls.length}',
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: Text(project.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text(project.companyName, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(project.category, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: catColor)),
                ),
              ),
            ),
            Expanded(
              child: Text(project.location, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text(project.completionDate.isNotEmpty ? project.completionDate : '-', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            ),

            // Actions: View & Delete
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 19, color: AppColors.primary),
                    onPressed: () => _showProjectDetailsDialog(context, project),
                    tooltip: 'View Details & Photos',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 19, color: AppColors.statusDanger),
                    onPressed: () => _confirmDelete(context, project),
                    tooltip: 'Delete Project',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDetailsDialog(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 680),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text('${project.companyName} • ${project.location}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 14),

                // Photos Section
                if (project.imageUrls.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Project Photos (${project.imageUrls.length})',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.fullscreen, size: 16, color: AppColors.primary),
                        label: Text('Open Full Gallery', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary)),
                        onPressed: () {
                          FullscreenImageViewer.open(
                            context,
                            imageUrls: project.imageUrls,
                            title: project.title,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: project.imageUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            FullscreenImageViewer.open(
                              context,
                              imageUrls: project.imageUrls,
                              initialIndex: idx,
                              title: project.title,
                            );
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.network(
                                project.imageUrls[idx],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Overview & Engineering Highlights', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Text(
                          project.description.isNotEmpty ? project.description : 'No description provided.',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Text('Category: ${project.category}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('Completed on: ${project.completionDate.isNotEmpty ? project.completionDate : "N/A"}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
