import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/palette.dart';
import 'fullscreen_image_viewer.dart';

/// ============================================================================
/// FILE: multi_image_picker_field.dart
/// MODULE: Core Common Utils (Multi-Image Form Component)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Reusable form field that allows constructors to pick unlimited images
///   from gallery or camera, preview existing and new photos, inspect file
///   sizes, remove any image, and view images fullscreen.
/// ============================================================================

class MultiImagePickerField extends StatefulWidget {
  final List<String> initialUrls;
  final List<XFile> initialFiles;
  final void Function(List<String> existingUrls, List<XFile> newFiles) onChanged;
  final String title;
  final String? subtitle;

  const MultiImagePickerField({
    super.key,
    this.initialUrls = const [],
    this.initialFiles = const [],
    required this.onChanged,
    this.title = 'Images & Architectural Designs',
    this.subtitle,
  });

  @override
  State<MultiImagePickerField> createState() => _MultiImagePickerFieldState();
}

class _MultiImagePickerFieldState extends State<MultiImagePickerField> {
  late List<String> _existingUrls;
  late List<XFile> _newFiles;
  final ImagePicker _picker = ImagePicker();
  final Map<String, int> _fileSizes = {};

  @override
  void initState() {
    super.initState();
    _existingUrls = List.from(widget.initialUrls);
    _newFiles = List.from(widget.initialFiles);
    _loadFileSizes();
  }

  Future<void> _loadFileSizes() async {
    for (final f in _newFiles) {
      if (!_fileSizes.containsKey(f.path)) {
        final bytes = await f.length();
        _fileSizes[f.path] = bytes;
      }
    }
    if (mounted) setState(() {});
  }

  void _notifyChange() {
    widget.onChanged(_existingUrls, _newFiles);
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          _newFiles.addAll(picked);
        });
        for (final f in picked) {
          final len = await f.length();
          _fileSizes[f.path] = len;
        }
        if (mounted) setState(() {});
        _notifyChange();
      }
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final len = await photo.length();
        _fileSizes[photo.path] = len;
        setState(() {
          _newFiles.add(photo);
        });
        _notifyChange();
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void _removeExisting(int index) {
    setState(() {
      _existingUrls.removeAt(index);
    });
    _notifyChange();
  }

  void _removeNew(int index) {
    setState(() {
      final removed = _newFiles.removeAt(index);
      _fileSizes.remove(removed.path);
    });
    _notifyChange();
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _existingUrls.length + _newFiles.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with count badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: totalCount > 0 ? AppColors.secondary.withValues(alpha: 0.12) : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 14,
                    color: totalCount > 0 ? AppColors.secondary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    totalCount == 0 ? 'No photos' : '$totalCount photo${totalCount == 1 ? '' : 's'}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: totalCount > 0 ? AppColors.secondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.subtitle ?? 'Add unlimited photos, elevation blueprints & designs. Auto-compressed to ≤ 3MB.',
          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),

        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickFromGallery,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(
                  'Pick From Gallery',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _takePhoto,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: Text(
                  'Take Photo',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Image Thumbnails Grid / List
        if (totalCount > 0)
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Render Existing Uploaded Images
                ...List.generate(_existingUrls.length, (i) {
                  final url = _existingUrls[i];
                  return _buildExistingImageCard(url, i);
                }),

                // Render Newly Picked Local Files
                ...List.generate(_newFiles.length, (i) {
                  final file = _newFiles[i];
                  final size = _fileSizes[file.path] ?? 0;
                  return _buildNewFileCard(file, size, i);
                }),

                // "+ Add More" Tile
                _buildAddMoreTile(),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.textMuted),
                const SizedBox(height: 8),
                Text(
                  'No images added yet',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap "Pick From Gallery" or "Take Photo" to upload.',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExistingImageCard(String url, int index) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: GestureDetector(
              onTap: () {
                FullscreenImageViewer.open(
                  context,
                  imageUrls: _existingUrls,
                  initialIndex: index,
                  title: 'Published Photo',
                );
              },
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: AppColors.textMuted),
                ),
              ),
            ),
          ),
          // "Uploaded" badge
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Uploaded',
                style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          // Delete button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeExisting(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.statusDanger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewFileCard(XFile file, int bytes, int index) {
    final bool exceedsLimit = bytes > (3 * 1024 * 1024);

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: exceedsLimit ? AppColors.secondary : AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: kIsWeb
                ? FutureBuilder<Uint8List>(
                    future: file.readAsBytes(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Image.memory(snap.data!, fit: BoxFit.cover);
                      }
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                    },
                  )
                : Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                  ),
          ),
          // Size & Compression badge
          Positioned(
            bottom: 6,
            left: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                exceedsLimit ? '${_formatBytes(bytes)} (Auto ≤3MB)' : _formatBytes(bytes),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: exceedsLimit ? AppColors.tagTrending : Colors.white,
                ),
              ),
            ),
          ),
          // Delete button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeNew(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.statusDanger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreTile() {
    return GestureDetector(
      onTap: _pickFromGallery,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 20, color: AppColors.secondary),
            ),
            const SizedBox(height: 6),
            Text(
              'Add More',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
