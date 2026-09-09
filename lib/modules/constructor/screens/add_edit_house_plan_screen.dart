import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/media_upload_service.dart';
import '../../../core/common/utils/multi_image_picker_field.dart';

/// ============================================================================
/// FILE: add_edit_house_plan_screen.dart
/// MODULE: Constructor Module (Floor Plan Creator UI Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides house plan creation and editing form controls. Uses MediaQuery
///   for responsive layout sizing and prevents RenderFlex overflows on all
///   mobile and web display resolutions.
/// ============================================================================

class AddEditHousePlanScreen extends StatefulWidget {
  final HousePlanModel? plan;
  const AddEditHousePlanScreen({super.key, this.plan});

  @override
  State<AddEditHousePlanScreen> createState() => _AddEditHousePlanScreenState();
}

class _AddEditHousePlanScreenState extends State<AddEditHousePlanScreen> {
  final _titleController = TextEditingController();
  final _bhkController = TextEditingController();
  final _sqftController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> _existingImageUrls = [];
  List<XFile> _newImageFiles = [];

  String _selectedTag = 'Bestseller';
  bool _isLoading = false;
  String _uploadStatus = '';

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _titleController.text = widget.plan!.title;
      _bhkController.text = widget.plan!.bhk;
      _sqftController.text = widget.plan!.sqft.toString();
      _priceController.text = widget.plan!.contractPrice.toString();
      _descriptionController.text = widget.plan!.description;
      _existingImageUrls = List.from(widget.plan!.imageUrls);
      if (widget.plan!.tag.isNotEmpty) {
        _selectedTag = widget.plan!.tag;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bhkController.dispose();
    _sqftController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    if (_titleController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Plan Title and Contract Price.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadStatus = 'Preparing architectural designs...';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userDoc = await AuthService().getUserData().first;
      final companyName = (userDoc?.fullName.isNotEmpty == true) ? userDoc!.fullName : 'BuildWell Constructions';

      // Upload newly picked images (with automatic compression to <= 3MB)
      List<String> newlyUploadedUrls = [];
      if (_newImageFiles.isNotEmpty) {
        newlyUploadedUrls = await MediaUploadService().uploadMultipleImages(
          _newImageFiles,
          onProgress: (current, total) {
            if (mounted) {
              setState(() {
                _uploadStatus = 'Compressing & uploading plan $current of $total...';
              });
            }
          },
        );
      }

      final allImageUrls = [..._existingImageUrls, ...newlyUploadedUrls];

      setState(() {
        _uploadStatus = 'Saving house plan to database...';
      });

      final plan = HousePlanModel(
        id: widget.plan?.id ?? '',
        companyId: user?.uid ?? 'comp_1',
        companyName: companyName,
        title: _titleController.text.trim(),
        bhk: _bhkController.text.trim().isEmpty ? '3BHK' : _bhkController.text.trim(),
        sqft: int.tryParse(_sqftController.text.trim()) ?? 2000,
        contractPrice: double.tryParse(_priceController.text.trim()) ?? 4500000,
        description: _descriptionController.text.trim(),
        imageUrls: allImageUrls,
        tag: _selectedTag,
        features: ['Solar Ready', 'Car Porch', 'Modular Kitchen'],
      );

      await HousePlanService().addOrUpdateHousePlan(plan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('House Plan ${widget.plan == null ? "created" : "updated"} successfully!')),
        );
        Navigator.pop(context);
      }
    } on FirebaseException catch (fe) {
      if (mounted) {
        if (fe.code == 'permission-denied') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Firestore Permission Error'),
              content: const Text(
                'Firestore denied permission to save the house plan.\n\n'
                'Please update your Firestore Security Rules in Firebase Console to allow write access:\n'
                'allow read, write: if request.auth != null;',
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving plan: ${fe.message}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving plan: ${e.toString()}')),
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

    final double hPadding = (w * 0.04).clamp(12.0, 24.0);
    final double vPadding = (h * 0.02).clamp(10.0, 20.0);
    final double fieldGap = (h * 0.018).clamp(12.0, 20.0);
    final double labelFontSize = (w * 0.033).clamp(11.0, 15.0);
    final double inputFontSize = (w * 0.036).clamp(12.0, 16.0);
    final double buttonHeight = (h * 0.06).clamp(46.0, 56.0);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: AppColors.getTextPrimary(context), size: (w * 0.06).clamp(20.0, 28.0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.plan == null ? 'Add New House Plan' : 'Edit House Plan',
          style: GoogleFonts.poppins(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: (w * 0.043).clamp(15.0, 20.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(hPadding, vPadding, hPadding, h * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field 1: Plan Title
            Text('Plan Title',
                style: GoogleFonts.poppins(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context))),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _titleController,
              style: GoogleFonts.poppins(
                  fontSize: inputFontSize, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText: 'e.g. Modern Nordic Villa',
                hintStyle: GoogleFonts.poppins(
                    fontSize: inputFontSize, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.035, vertical: h * 0.014),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
              ),
            ),
            SizedBox(height: fieldGap),

            // Field 2 & 3: BHK & Sq.Ft Row (Responsive Flex Layout)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BHK Type',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextPrimary(context))),
                      SizedBox(height: h * 0.006),
                      TextField(
                        controller: _bhkController,
                        style: GoogleFonts.poppins(
                            fontSize: inputFontSize,
                            color: AppColors.getTextPrimary(context)),
                        decoration: InputDecoration(
                          hintText: '3BHK',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: inputFontSize, color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.getCardBackground(context),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w * 0.035, vertical: h * 0.014),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              borderSide:
                                  BorderSide(color: AppColors.getBorderLight(context))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              borderSide:
                                  BorderSide(color: AppColors.getBorderLight(context))),
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
                      Text('Square Feet (Sq.Ft)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextPrimary(context))),
                      SizedBox(height: h * 0.006),
                      TextField(
                        controller: _sqftController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(
                            fontSize: inputFontSize,
                            color: AppColors.getTextPrimary(context)),
                        decoration: InputDecoration(
                          hintText: '2400',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: inputFontSize, color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.getCardBackground(context),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w * 0.035, vertical: h * 0.014),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              borderSide:
                                  BorderSide(color: AppColors.getBorderLight(context))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              borderSide:
                                  BorderSide(color: AppColors.getBorderLight(context))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: fieldGap),

            // Field 4: Contract Price
            Text('Contract Price (in ₹ INR)',
                style: GoogleFonts.poppins(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context))),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                  fontSize: inputFontSize, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText: '4800000',
                hintStyle: GoogleFonts.poppins(
                    fontSize: inputFontSize, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.035, vertical: h * 0.014),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
              ),
            ),
            SizedBox(height: fieldGap),

            // Field 5: Badge Tag
            Text('Badge Tag',
                style: GoogleFonts.poppins(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context))),
            SizedBox(height: h * 0.006),
            DropdownButtonFormField<String>(
              initialValue: _selectedTag,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.035, vertical: h * 0.014),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
              ),
              items: ['Bestseller', 'Trending', 'New', 'Featured'].map((t) {
                return DropdownMenuItem(
                    value: t,
                    child: Text(t,
                        style: GoogleFonts.poppins(
                            fontSize: inputFontSize,
                            color: AppColors.getTextPrimary(context))));
              }).toList(),
              onChanged: (val) =>
                  setState(() => _selectedTag = val ?? 'Bestseller'),
            ),
            SizedBox(height: fieldGap),

            // Field 6: Multi-Image Picker Component
            MultiImagePickerField(
              title: 'House Plan Blueprints',
              subtitle:
                  'Upload multiple floor plans, 2D blueprints, elevation renders & layouts. Auto-compressed to ≤ 3MB.',
              initialUrls: _existingImageUrls,
              initialFiles: _newImageFiles,
              onChanged: (existing, newFiles) {
                _existingImageUrls = existing;
                _newImageFiles = newFiles;
              },
            ),
            SizedBox(height: fieldGap),

            // Field 7: Description & Highlights
            Text('Description & Highlights',
                style: GoogleFonts.poppins(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context))),
            SizedBox(height: h * 0.006),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(
                  fontSize: inputFontSize, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText:
                    'Describe floor specs, exterior finish, bedroom layouts...',
                hintStyle: GoogleFonts.poppins(
                    fontSize: inputFontSize, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.035, vertical: h * 0.014),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: BorderSide(color: AppColors.getBorderLight(context))),
              ),
            ),
            SizedBox(height: fieldGap * 1.5),
          ],
        ),
      ),

      // Fixed Primary Action Button in Bottom Navigation Bar (Prevents Vertical Overflows)
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: hPadding, vertical: (h * 0.015).clamp(8.0, 16.0)),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(context),
            border: Border(
                top: BorderSide(
                    color: AppColors.getBorderLight(context), width: 1.0)),
            boxShadow: const [
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
                  padding: EdgeInsets.only(bottom: h * 0.008),
                  child: Text(
                    _uploadStatus,
                    style: GoogleFonts.poppins(
                        fontSize: (w * 0.03).clamp(10.0, 13.0),
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.03)),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: (w * 0.05).clamp(18.0, 24.0),
                          width: (w * 0.05).clamp(18.0, 24.0),
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          widget.plan == null
                              ? 'Publish House Plan'
                              : 'Save Plan Changes',
                          style: GoogleFonts.poppins(
                              fontSize: (w * 0.038).clamp(13.0, 17.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
