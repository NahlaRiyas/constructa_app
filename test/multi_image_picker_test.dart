import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:constructa_app/core/common/utils/multi_image_picker_field.dart';

void main() {
  testWidgets('MultiImagePickerField renders title, action buttons, and existing images', (WidgetTester tester) async {
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

    final existing = [
      'https://example.com/plan_elevation.jpg',
      'https://example.com/plan_floor.jpg',
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MultiImagePickerField(
              title: 'House Plan Blueprints',
              subtitle: 'Upload multi-angle floor plans',
              initialUrls: existing,
              onChanged: (urls, files) {},
            ),
          ),
        ),
      ),
    );

    // Verify title and subtitle
    expect(find.text('House Plan Blueprints'), findsOneWidget);
    expect(find.text('Upload multi-angle floor plans'), findsOneWidget);

    // Verify action buttons
    expect(find.text('Pick From Gallery'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);

    // Verify existing images counter badge
    expect(find.text('2 photos'), findsOneWidget);
  });
}
