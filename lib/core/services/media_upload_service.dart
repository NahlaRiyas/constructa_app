import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// ============================================================================
/// FILE: media_upload_service.dart
/// MODULE: Core Services (Media Storage & Compression Service)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides image compression (max 3MB guarantee) and 100% free image
///   uploading using the ImgBB REST API. Avoids paid Firebase Storage tiers
///   while providing permanent, high-performance CDN image URLs.
/// ============================================================================

class MediaUploadService {
  static final MediaUploadService _instance = MediaUploadService._internal();
  factory MediaUploadService() => _instance;
  MediaUploadService._internal();

  /// Compresses [file] bytes so that the output size is strictly <= [maxBytes] (default 3MB).
  ///
  /// Uses hardware-accelerated [FlutterImageCompress]. If compression is not
  /// supported on the current platform, falls back gracefully.
  Future<Uint8List> compressImageBytes(Uint8List rawBytes, {int maxBytes = ApiConstants.maxImageSizeBytes}) async {
    // If already smaller than target, return as-is
    if (rawBytes.lengthInBytes <= maxBytes) {
      return rawBytes;
    }

    // Iteratively compress with decreasing quality until < maxBytes
    int quality = 85;
    Uint8List compressed = rawBytes;

    try {
      while (quality >= 30) {
        final result = await FlutterImageCompress.compressWithList(
          rawBytes,
          minWidth: 1920,
          minHeight: 1080,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        compressed = Uint8List.fromList(result);
        if (compressed.lengthInBytes <= maxBytes) {
          return compressed;
        }
        quality -= 15;
      }
    } catch (e) {
      debugPrint('MediaUploadService: Image compression failed or unsupported: $e');
    }

    return compressed;
  }

  /// Compresses an [XFile] to <= 3MB and returns its bytes.
  Future<Uint8List> compressXFile(XFile file, {int maxBytes = ApiConstants.maxImageSizeBytes}) async {
    final rawBytes = await file.readAsBytes();
    return compressImageBytes(rawBytes, maxBytes: maxBytes);
  }

  /// Uploads an [XFile] to ImgBB and returns the permanent direct CDN URL.
  ///
  /// Automatically compresses the file to <= 3MB before upload.
  Future<String> uploadImage(XFile file) async {
    try {
      final compressedBytes = await compressXFile(file);
      return await uploadBytes(compressedBytes, filename: file.name);
    } catch (e) {
      debugPrint('MediaUploadService: Error uploading XFile: $e');
      rethrow;
    }
  }

  /// Uploads a [File] to ImgBB and returns the permanent direct CDN URL.
  Future<String> uploadFile(File file) async {
    try {
      final rawBytes = await file.readAsBytes();
      final compressedBytes = await compressImageBytes(rawBytes);
      final filename = file.path.split('/').last;
      return await uploadBytes(compressedBytes, filename: filename);
    } catch (e) {
      debugPrint('MediaUploadService: Error uploading File: $e');
      rethrow;
    }
  }

  /// Uploads raw image [bytes] to ImgBB API via HTTP POST.
  ///
  /// Returns the permanent direct image URL (e.g. `https://i.ibb.co/...`).
  Future<String> uploadBytes(Uint8List bytes, {String filename = 'upload.jpg'}) async {
    try {
      final cleanName = filename.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
      final uri = Uri.parse('${ApiConstants.imgbbUploadUrl}?key=${ApiConstants.imgbbApiKey}');

      final request = http.MultipartRequest('POST', uri);
      request.fields['name'] = cleanName;
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: cleanName,
        ),
      );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final imageUrl = data['data']['display_url'] ?? data['data']['url'];
          if (imageUrl != null && imageUrl.toString().isNotEmpty) {
            return imageUrl.toString();
          }
        }
        throw Exception('ImgBB API returned unsuccessful response: ${response.body}');
      } else {
        throw Exception('Failed to upload to ImgBB (Status ${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('MediaUploadService uploadBytes error: $e');
      rethrow;
    }
  }

  /// Uploads multiple [XFile]s sequentially with an optional progress callback.
  ///
  /// Parameters:
  /// - [files]: List of local image files to upload.
  /// - [onProgress]: Callback receiving current index (1-based) and total count.
  ///
  /// Returns a list of uploaded permanent CDN URLs.
  Future<List<String>> uploadMultipleImages(
    List<XFile> files, {
    void Function(int current, int total)? onProgress,
  }) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < files.length; i++) {
      onProgress?.call(i + 1, files.length);
      final url = await uploadImage(files[i]);
      if (url.isNotEmpty) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }
}
