import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lets_cook/Components/MealPage/CollapsableList.dart'; // Replace 'your_package_path' with the actual path to your CollapsableList.dart file


void main() {
  testWidgets('CollapsableList initial state', (WidgetTester tester) async {
    // Build the CollapsableList widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CollapsableList(
            title: 'Test Title',
            child: Container(), // Add any child widget for testing
          ),
        ),
      ),
    );

    // Verify that the title text is displayed
    expect(find.text('Test Title'), findsOneWidget);

  });

  testWidgets('CollapsableList toggle expansion', (WidgetTester tester) async {
    // Build the CollapsableList widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CollapsableList(
            title: 'Test Title',
            child: Container(), // Add any child widget for testing
          ),
        ),
      ),
    );

    // Tap on the IconButton to toggle expansion
    await tester.tap(find.byType(IconButton).first);
    await tester.pump();

    // Verify that the child widget is now visible after expansion
    expect(find.byType(Container), findsOneWidget);

  });
}


