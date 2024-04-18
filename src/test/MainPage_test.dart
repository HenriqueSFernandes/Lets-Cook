import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/Components/HomePage/ProductCard.dart';

void main() {
  testWidgets('HomePage widget test', (WidgetTester tester) async {

    // Initialize the HomePage with the FakeFirebaseFirestore instance
    final homePage = HomePage();

    // Build the HomePage widget
    await tester.pumpWidget(MaterialApp(home: homePage));

    // Wait for the snapshot listener to process the data
    await tester.pump();

    // Verify that the ProductCard widget is rendered
    expect(find.byType(Product), findsOneWidget);

    // Verify that the product details are displayed correctly
    expect(find.text('John Doe'), findsOneWidget); // Verify username
    expect(find.text('Test Meal'), findsOneWidget); // Verify mealname
    expect(find.text('10.50'), findsOneWidget); // Verify price
    expect(find.text('Test Description'), findsOneWidget); // Verify description
    expect(find.text('123456'), findsOneWidget); // Verify userid
    expect(find.text('Ingredient 1'), findsOneWidget); // Verify ingredients
    expect(find.text('Ingredient 2'), findsOneWidget); // Verify ingredients
    expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is NetworkImage), findsOneWidget); // Verify images
  });
}