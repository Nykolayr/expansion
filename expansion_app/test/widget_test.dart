import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expansion/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage отображает заголовок', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byIcon(Icons.rocket_launch_outlined), findsOneWidget);
  });
}
