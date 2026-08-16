import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/project_service.dart';
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
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Completed Showcase Projects', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.secondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditProjectScreen()),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text('No completed projects added yet.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEditProjectScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text('Add Showcase Project', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final proj = projects[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (proj.imageUrls.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          proj.imageUrls.first,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                                Text(proj.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                                Text('${proj.category} • ${proj.location}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.statusDanger),
                            onPressed: () async {
                              await ProjectService().deleteProject(proj.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project deleted.')));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
