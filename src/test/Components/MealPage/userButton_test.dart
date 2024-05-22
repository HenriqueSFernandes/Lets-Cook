import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/Components/MealPage/UserButton.dart'; // Import your UserButton.dart file

void main() {
  testWidgets('UserButton Widget Test', (WidgetTester tester) async {
    // Mock data for testing
    final String userName = 'John Doe';
    final String userID = '123456';
    final String mealID = '654321';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserButton(
            userName: userName,
            userID: userID,
            mealID: mealID,
          ),
        ),
      ),
    );

    // Expectations
    expect(find.text(userName), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('UserButton Widget Dialog Test', (WidgetTester tester) async {
    // Mock data for testing
    final String userName = 'John Doe';
    final String userID = '123456';
    final String mealID = '654321';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserButton(
            userName: userName,
            userID: userID,
            mealID: mealID,
          ),
        ),
      ),
    );

    // Tap on the UserButton widget to trigger dialog
    await tester.tap(find.text(userName));
    await tester.pumpAndSettle();

    // Expectation
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Feature not implemented!"), findsOneWidget);
    expect(find.text("This feature is yet to be implemented."), findsOneWidget);
    expect(find.text("Ok"), findsOneWidget);
  });

  testWidgets('UserButton Widget Dialog Dismiss Test', (WidgetTester tester) async {
    // Mock data for testing
    final String userName = 'John Doe';
    final String userID = '123456';
    final String mealID = '654321';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserButton(
            userName: userName,
            userID: userID,
            mealID: mealID,
          ),
        ),
      ),
    );

    // Tap on the UserButton widget to trigger dialog
    await tester.tap(find.text(userName));
    await tester.pumpAndSettle();

    // Tap on "Ok" button to dismiss dialog
    await tester.tap(find.text("Ok"));
    await tester.pumpAndSettle();

    // Expectation
    expect(find.byType(AlertDialog), findsNothing);
  });
}
