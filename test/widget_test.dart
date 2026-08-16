import 'package:flutter_test/flutter_test.dart';
import 'package:constructa_app/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const ConstructaApp());
    expect(find.byType(ConstructaApp), findsOneWidget);
  });
}
