import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:constructa_app/core/common/utils/fullscreen_image_viewer.dart';

void main() {
  testWidgets('FullscreenImageViewer renders page counter and close button', (WidgetTester tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException ||
          details.exception.toString().contains('HTTP request failed') ||
          details.exception.toString().contains('statusCode: 400')) {
        return;
      }
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    final images = [
      'https://example.com/photo1.jpg',
      'https://example.com/photo2.jpg',
      'https://example.com/photo3.jpg',
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: FullscreenImageViewer(
          imageUrls: images,
          initialIndex: 0,
          title: 'Custom Modern Villa',
        ),
      ),
    );

    // Verify title and page counter text
    expect(find.text('Custom Modern Villa'), findsOneWidget);
    expect(find.text('Photo 1 of 3'), findsOneWidget);

    // Verify close icon button is present
    expect(find.byIcon(Icons.close), findsOneWidget);

    // Verify interactive viewer is present
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });
}
