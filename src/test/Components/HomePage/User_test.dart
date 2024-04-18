import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/Components/HomePage/Username.dart'; // Replace with your actual import path

void main() {
  testWidgets('UserWidget Test', (WidgetTester tester) async {
    // Define a test username
    const testUsername = 'Test User';

    // Build the UserWidget in a test environment
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(testUsername),
        ),
      ),
    );

    // Verify that the UserWidget is built correctly
    expect(find.byType(UserWidget), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);

    // Verify that the UserWidget displays the correct username
    expect(find.text(testUsername), findsOneWidget);
  });
}