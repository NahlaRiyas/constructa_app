import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/project_service.dart';

class AddEditProjectScreen extends StatefulWidget {
  final ProjectModel? project;
  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _completionDateController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.title;
      _categoryController.text = widget.project!.category;
      _locationController.text = widget.project!.location;
      _completionDateController.text = widget.project!.completionDate;
      _imageUrlController.text = widget.project!.imageUrls.isNotEmpty ? widget.project!.imageUrls.first : '';
      _descriptionController.text = widget.project!.description;
    }
  }

  Future<void> _saveProject() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Project Title.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final proj = ProjectModel(
        id: widget.project?.id ?? '',
        companyId: user?.uid ?? 'comp_1',
        companyName: user?.displayName ?? 'BuildWell Constructions',
        title: _titleController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'Construction' : _categoryController.text.trim(),
        location: _locationController.text.trim().isEmpty ? 'Kochi, Kerala' : _locationController.text.trim(),
        completionDate: _completionDateController.text.trim().isEmpty ? 'Aug 2026' : _completionDateController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrls: _imageUrlController.text.trim().isNotEmpty ? [_imageUrlController.text.trim()] : [],
      );

      await ProjectService().addOrUpdateProject(proj);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showcase Project ${widget.project == null ? "added" : "updated"}!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving project: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.project == null ? 'Add Showcase Project' : 'Edit Showcase Project',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Title', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Kochi Waterfront Villa',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _categoryController,
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Construction',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Completion Date', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _completionDateController,
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'May 2026',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Text('Site Location', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _locationController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Kochi, Kerala',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Project Photo Image URL', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _imageUrlController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'https://...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Project Details & Engineering Highlights', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Completed 3400 sq.ft ultra-modern villa with custom piles and anti-humidity waterproofing...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.project == null ? 'Publish Showcase Project' : 'Save Project Changes', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
