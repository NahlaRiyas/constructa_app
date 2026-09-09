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
    // MediaQuery Responsive Dimension Calculations
    final screenSize = MediaQuery.of(context).size;
    final w = screenSize.width;
    final h = screenSize.height;

    final double hPadding = w * 0.04; // 4% width
    final double vPadding = h * 0.02; // 2% height
    final double fieldGap = h * 0.018; // 1.8% height
    final double titleFontSize = w * 0.033; // ~13.2pt
    final double inputFontSize = w * 0.036; // ~14.4pt
    final double buttonHeight = h * 0.06; // 6% height

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: w * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.project == null ? 'Add Showcase Project' : 'Edit Showcase Project',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: w * 0.043),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(hPadding, vPadding, hPadding, h * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Title', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _titleController,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Kochi Waterfront Villa',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      SizedBox(height: h * 0.006),
                      TextField(
                        controller: _categoryController,
                        style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Construction',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Completion Date', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      SizedBox(height: h * 0.006),
                      TextField(
                        controller: _completionDateController,
                        style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'May 2026',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: fieldGap),

            Text('Site Location', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _locationController,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Kochi, Kerala',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),

            // Multi-Image Picker Field
            SizedBox(
              width: w,
              child: MultiImagePickerField(
                title: 'Project Photos & Designs',
                subtitle: 'Upload site pictures, interiors, elevations & finished views. Compressed to ≤ 3MB.',
                initialUrls: _existingImageUrls,
                initialFiles: _newImageFiles,
                onChanged: (existing, newFiles) {
                  _existingImageUrls = existing;
                  _newImageFiles = newFiles;
                },
              ),
            ),
            SizedBox(height: fieldGap),

            Text('Project Details & Engineering Highlights', style: GoogleFonts.poppins(fontSize: titleFontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: inputFontSize, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Completed 3400 sq.ft ultra-modern villa with custom piles and anti-humidity waterproofing...',
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.03), borderSide: BorderSide(color: AppColors.borderLight)),
              ),
            ),
            SizedBox(height: fieldGap),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: h * 0.018),
          decoration:  BoxDecoration(
            color: AppColors.cardBackground,
            border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.0)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading && _uploadStatus.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: h * 0.01),
                  child: Text(
                    _uploadStatus,
                    style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w500, color: AppColors.secondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.03)),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: w * 0.05,
                          width: w * 0.05,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          widget.project == null ? 'Publish Showcase Project' : 'Save Project Changes',
                          style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
