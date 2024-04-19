import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:lets_cook/Components/HomePage/ProductCard.dart'; // Replace with your actual import path

void main() {
  testWidgets('Product widget test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Define test data
      final testUserName = 'Test User';
      final testDishName = 'Test Dish';
      final testPrice = 10.0;
      final testDescription = 'Test Description';
      final testUserID = 'Test UserID';
      final testImageURLs = ['https://example.com/image.jpg'];
      final testIngredients = ['Ingredient 1', 'Ingredient 2'];

      // Build the Product widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Product(
              userName: testUserName,
              dishName: testDishName,
              price: testPrice,
              description: testDescription,
              userID: testUserID,
              imageURLs: testImageURLs,
              ingredients: testIngredients,
            ),
          ),
        ),
      );

      // Verify that the Product widget is built correctly
      expect(find.byType(Product), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsExactly(2));
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Row), findsWidgets);

      // Verify that the Product widget displays the correct data
      expect(find.text(testUserName), findsOneWidget);
      expect(find.text(testDishName), findsOneWidget);
      expect(find.text(testPrice.toStringAsFixed(2) + '€'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget); // Verify rating
    });
  });
}