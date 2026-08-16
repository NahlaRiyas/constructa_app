import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/palette.dart';
import '../../../core/models/house_plan_model.dart';
import '../../../core/services/house_plan_service.dart';
import '../../../core/services/auth_service.dart';

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
  final _imageUrlController = TextEditingController();
  String _selectedTag = 'Bestseller';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _titleController.text = widget.plan!.title;
      _bhkController.text = widget.plan!.bhk;
      _sqftController.text = widget.plan!.sqft.toString();
      _priceController.text = widget.plan!.contractPrice.toString();
      _descriptionController.text = widget.plan!.description;
      _imageUrlController.text = widget.plan!.imageUrls.isNotEmpty ? widget.plan!.imageUrls.first : '';
      if (widget.plan!.tag.isNotEmpty) {
        _selectedTag = widget.plan!.tag;
      }
    }
  }

  Future<void> _savePlan() async {
    if (_titleController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Plan Title and Contract Price.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userDoc = await AuthService().getUserData().first;
      final companyName = (userDoc?.fullName.isNotEmpty == true) ? userDoc!.fullName : 'BuildWell Constructions';

      final plan = HousePlanModel(
        id: widget.plan?.id ?? '',
        companyId: user?.uid ?? 'comp_1',
        companyName: companyName,
        title: _titleController.text.trim(),
        bhk: _bhkController.text.trim().isEmpty ? '3BHK' : _bhkController.text.trim(),
        sqft: int.tryParse(_sqftController.text.trim()) ?? 2000,
        contractPrice: double.tryParse(_priceController.text.trim()) ?? 4500000,
        description: _descriptionController.text.trim(),
        imageUrls: _imageUrlController.text.trim().isNotEmpty ? [_imageUrlController.text.trim()] : [],
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
                'Firestore denied permission to create the house plan.\n\n'
                'Please update your Firestore Security Rules in the Firebase Console to allow write access:\n'
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
          widget.plan == null ? 'Add New House Plan' : 'Edit House Plan',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan Title', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Modern Nordic Villa',
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
                      Text('BHK (e.g. 3BHK)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _bhkController,
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '3BHK',
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
                      Text('Square Feet (Sq.Ft)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _sqftController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '2400',
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

            Text('Contract Price (in ₹ INR)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '4800000',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 14),

            Text('Badge Tag', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedTag,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
              items: ['Bestseller', 'Trending', 'New', 'Featured'].map((t) {
                return DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.poppins(fontSize: 14)));
              }).toList(),
              onChanged: (val) => setState(() => _selectedTag = val ?? 'Bestseller'),
            ),
            const SizedBox(height: 14),

            Text('House Plan Image URL', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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

            Text('Description & Highlights', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Describe floor specs, exterior finish, bedroom layouts...',
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
                onPressed: _isLoading ? null : _savePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.plan == null ? 'Publish House Plan' : 'Save Plan Changes', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
