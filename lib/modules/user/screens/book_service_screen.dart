import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../theme/palette.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/auth_service.dart';

class BookServiceScreen extends StatefulWidget {
  final String companyId;
  final String companyName;
  final String planId;
  final String planTitle;

  const BookServiceScreen({
    super.key,
    this.companyId = 'comp_1',
    this.companyName = 'BuildWell Constructions',
    this.planId = 'plan_1',
    this.planTitle = 'Modern Nordic Villa (3BHK)',
  });

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  String _selectedTimeSlot = '10:00 AM';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> _timeSlots = ['09:30 AM', '11:00 AM', '02:30 PM', '04:30 PM'];

  @override
  void initState() {
    super.initState();
    // Prefill phone from logged in user if available
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      AuthService().getUserData().first.then((user) {
        if (user != null && user.phoneNumber.isNotEmpty) {
          _phoneController.text = user.phoneNumber;
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'Customer';
    final userId = user?.uid ?? 'guest_user';

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a contact phone number.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedDate = DateFormat('MMM dd, yyyy').format(_selectedDate);
      final booking = BookingModel(
        id: '',
        userId: userId,
        userName: userName,
        userPhone: _phoneController.text.trim(),
        companyId: widget.companyId,
        companyName: widget.companyName,
        planId: widget.planId,
        planTitle: widget.planTitle,
        bookingDate: formattedDate,
        timeSlot: _selectedTimeSlot,
        status: 'Pending',
        notes: _notesController.text.trim(),
        createdAt: DateTime.now().toString(),
      );

      await BookingService().createBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit booking: ${e.toString()}')),
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
    final formattedDateStr = DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Book Service / Consultation', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contractor', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text(widget.companyName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const Divider(height: 20),
                  Text('Selected House Plan / Service', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text(widget.planTitle, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker Section
            Text('Select Date', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDateStr, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const Icon(Icons.calendar_month, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slot Selection
            Text('Select Time Slot', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return ChoiceChip(
                  selected: isSelected,
                  label: Text(slot, style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 13)),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceLight,
                  onSelected: (val) => setState(() => _selectedTimeSlot = slot),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Contact Phone Number
            Text('Contact Phone Number', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                hintText: '+91 98765 43210',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 20),

            // Notes & Plot Location Details
            Text('Site Notes & Requirements (Optional)', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Specify plot location, square footage, budget constraints...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Confirm Booking Request', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
