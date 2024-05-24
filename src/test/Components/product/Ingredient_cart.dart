import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/Components/NewProductPage/IngredientCard.dart';

void main() {
  testWidgets('IngredientCard displays correct name', (WidgetTester tester) async {
    // Define a test ingredient name
    const String testIngredientName = 'Test Ingredient';

    // Build the IngredientCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientCard(
            name: testIngredientName,
          ),
        ),
      ),
    );

    // Verify that the IngredientCard displays the correct ingredient name
    expect(find.text(testIngredientName), findsOneWidget);
  });

  testWidgets('IngredientCard displays remove button when onRemove callback is provided', (WidgetTester tester) async {
    // Define a test ingredient name and create a mock onRemove callback
    const String testIngredientName = 'Test Ingredient';
    final VoidCallback? mockOnRemove = () {};

    // Build the IngredientCard widget with an onRemove callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientCard(
            name: testIngredientName,
            onRemove: mockOnRemove,
          ),
        ),
      ),
    );

    // Verify that the IngredientCard displays the remove button
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
  });

  testWidgets('IngredientCard does not display remove button when onRemove callback is not provided', (WidgetTester tester) async {
    // Define a test ingredient name
    const String testIngredientName = 'Test Ingredient';

    // Build the IngredientCard widget without an onRemove callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientCard(
            name: testIngredientName,
          ),
        ),
      ),
    );

    // Verify that the IngredientCard does not display the remove button
    expect(find.byIcon(Icons.cancel_outlined), findsNothing);
  });

  testWidgets('IngredientCard calls onRemove callback when remove button is tapped', (WidgetTester tester) async {
    // Define a test ingredient name and create a mock onRemove callback
    const String testIngredientName = 'Test Ingredient';
    bool removeCalled = false;
    void mockOnRemove() {
      removeCalled = true;
    }

    // Build the IngredientCard widget with an onRemove callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientCard(
            name: testIngredientName,
            onRemove: mockOnRemove,
          ),
        ),
      ),
    );

    // Tap the remove button
    await tester.tap(find.byIcon(Icons.cancel_outlined));

    // Verify that the onRemove callback is called
    expect(removeCalled, true);
  });
}
