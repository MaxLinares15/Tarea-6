import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max_app/main.dart';

void main() {
  testWidgets('Home screen loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Aplicación MultiTool'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
