import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:lets_cook/Components/HomePage/MealCard.dart'; // Replace with your actual import path

void main() {
  testWidgets('Product widget test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Define test data
      const testUserName = 'Test User';
      const testDishName = 'Test Dish';
      const testPrice = 10.0;
      const testDescription = 'Test Description';
      const testUserID = 'Test UserID';
      const testMealID = 'Test MealID';
      final testImageURLs = ['https://example.com/image.jpg'];
      final testIngredients = ['Ingredient 1', 'Ingredient 2'];

      // Build the Product widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              userName: testUserName,
              dishName: testDishName,
              price: testPrice,
              description: testDescription,
              userID: testUserID,
              mealID: testMealID,
              imageURLs: testImageURLs,
              ingredients: testIngredients,
            ),
          ),
        ),
      );

      // Verify that the Product widget is built correctly
      expect(find.byType(MealCard), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsExactly(2));
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Row), findsWidgets);

      // Verify that the Product widget displays the correct data
      expect(find.text(testUserName), findsOneWidget);
      expect(find.text(testDishName), findsOneWidget);
      expect(find.text('${testPrice.toStringAsFixed(2)}€'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget); // Verify rating
    });
  });
}