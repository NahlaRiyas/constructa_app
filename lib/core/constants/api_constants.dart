library;

/// ============================================================================
/// FILE: api_constants.dart
/// MODULE: Core Constants
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides configuration constants for external APIs, including free
///   image hosting via ImgBB.
/// ============================================================================

class ApiConstants {
  /// ImgBB API Key for free image hosting (no credit card required).
  ///
  /// You can get your own free API key in 30 seconds from https://api.imgbb.com/
  /// and replace it here anytime.
  static const String imgbbApiKey = '392b94f033c084e9ac8af0c7f82663de';

  /// ImgBB API upload endpoint.
  static const String imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  /// Maximum file size limit before compression (3 MB in bytes).
  static const int maxImageSizeBytes = 3 * 1024 * 1024; // 3,145,728 bytes
}
