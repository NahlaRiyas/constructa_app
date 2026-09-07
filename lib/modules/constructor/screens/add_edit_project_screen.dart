import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/project_model.dart';
import '../../../core/services/project_service.dart';
import '../../../core/services/media_upload_service.dart';
import '../../../core/common/utils/multi_image_picker_field.dart';

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
  final _descriptionController = TextEditingController();

  List<String> _existingImageUrls = [];
  List<XFile> _newImageFiles = [];

  bool _isLoading = false;
  String _uploadStatus = '';

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.title;
      _categoryController.text = widget.project!.category;
      _locationController.text = widget.project!.location;
      _completionDateController.text = widget.project!.completionDate;
      _descriptionController.text = widget.project!.description;
      _existingImageUrls = List.from(widget.project!.imageUrls);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _completionDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProject() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Project Title.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadStatus = 'Preparing project media...';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Upload newly picked images (with automatic compression to <= 3MB)
      List<String> newlyUploadedUrls = [];
      if (_newImageFiles.isNotEmpty) {
        newlyUploadedUrls = await MediaUploadService().uploadMultipleImages(
          _newImageFiles,
          onProgress: (current, total) {
            if (mounted) {
              setState(() {
                _uploadStatus = 'Compressing & uploading photo $current of $total...';
              });
            }
          },
        );
      }

      final allImageUrls = [..._existingImageUrls, ...newlyUploadedUrls];

      setState(() {
        _uploadStatus = 'Saving project details to database...';
      });

      final proj = ProjectModel(
        id: widget.project?.id ?? '',
        companyId: user?.uid ?? 'comp_1',
        companyName: (user?.displayName != null && user!.displayName!.isNotEmpty)
            ? user.displayName!
            : 'BuildWell Constructions',
        title: _titleController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'Construction' : _categoryController.text.trim(),
        location: _locationController.text.trim().isEmpty ? 'Kochi, Kerala' : _locationController.text.trim(),
        completionDate: _completionDateController.text.trim().isEmpty ? 'Aug 2026' : _completionDateController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrls: allImageUrls,
      );

      await ProjectService().addOrUpdateProject(proj);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showcase Project ${widget.project == null ? "added" : "updated"} successfully!')),
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
        setState(() {
          _isLoading = false;
          _uploadStatus = '';
        });
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
            const SizedBox(height: 16),

            // Multi-Image Picker Field
            MultiImagePickerField(
              title: 'Project Photos & Engineering Designs',
              subtitle: 'Upload site pictures, interiors, elevations & finished views. Compressed to ≤ 3MB.',
              initialUrls: _existingImageUrls,
              initialFiles: _newImageFiles,
              onChanged: (existing, newFiles) {
                _existingImageUrls = existing;
                _newImageFiles = newFiles;
              },
            ),
            const SizedBox(height: 16),

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

            // Upload Status text if loading
            if (_isLoading && _uploadStatus.isNotEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _uploadStatus,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.secondary),
                  ),
                ),
              ),
            ],

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
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        widget.project == null ? 'Publish Showcase Project' : 'Save Project Changes',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
