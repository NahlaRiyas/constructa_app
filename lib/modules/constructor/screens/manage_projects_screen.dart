import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/project_service.dart';
import '../../../core/common/utils/fullscreen_image_viewer.dart';
import 'add_edit_project_screen.dart';

class ManageProjectsScreen extends StatelessWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUid = FirebaseAuth.instance.currentUser?.uid ?? 'comp_1';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Showcase Projects',
            style: GoogleFonts.poppins(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined,
                color: AppColors.secondary),
            tooltip: 'Add Showcase Project',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEditProjectScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ProjectModel>>(
        stream: ProjectService().getProjects(companyId: companyUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final projects = snapshot.data ?? [];
          if (projects.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.business,
                                size: 54, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 16),
                          Text('No completed projects added yet.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          Text(
                              'Showcase site photos and completed building works to clients.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddEditProjectScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: Text('Add Showcase Project',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final proj = projects[index];
              return _buildAnimatedProjectCard(context, proj, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddEditProjectScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Project',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  /// Renders project showcase cards with entrance slide-up and fade-in animations.
  Widget _buildAnimatedProjectCard(
      BuildContext context, ProjectModel proj, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 24),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 8,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (proj.imageUrls.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        FullscreenImageViewer.open(
                          context,
                          imageUrls: proj.imageUrls,
                          title: proj.title,
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              proj.imageUrls.first,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 170,
                                color: AppColors.surfaceLight,
                                child: const Icon(Icons.image_not_supported,
                                    color: AppColors.textMuted),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.photo_library,
                                      size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${proj.imageUrls.length} photos',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(proj.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text('${proj.category} • ${proj.location}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        // Edit Button
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.primary),
                          tooltip: 'Edit Project',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditProjectScreen(project: proj)),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        // Delete Button
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.statusDanger),
                          tooltip: 'Delete Project',
                          onPressed: () => _confirmDelete(context, proj),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProjectModel proj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Project',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${proj.title}"?',
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ProjectService().deleteProject(proj.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Project deleted successfully.')));
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.statusDanger)),
          ),
        ],
      ),
    );
  }
}
