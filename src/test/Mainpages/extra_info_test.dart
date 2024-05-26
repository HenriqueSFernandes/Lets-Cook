import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/MainPages/ExtraInfoPage.dart';

void main() {
  group('ExtraInfoPage widget', () {
    testWidgets('ExtraInfoPage can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExtraInfoPage(),
        ),
      );

      expect(find.byType(ExtraInfoPage), findsOneWidget);
    });


  });
}