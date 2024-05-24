import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/MainPages/SearchPage.dart';
import 'package:lets_cook/Components/NewProductPage/MealIngredientInput.dart';
import 'package:lets_cook/Components/NewProductPage/IngredientCard.dart';

void main() {
  group('SearchPage widget', () {
    testWidgets('SearchPage can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPage(
            searchText: '',
            ingredients: [],
            cooks: [],
            minPrice: 0,
            maxPrice: 50,
          ),
        ),
      );

      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('AppBar is present with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPage(
            searchText: '',
            ingredients: [],
            cooks: [],
            minPrice: 0,
            maxPrice: 50,
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Search Page'), findsOneWidget);
    });

    testWidgets('RangeSlider is present with correct initial values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPage(
            searchText: '',
            ingredients: [],
            cooks: [],
            minPrice: 0,
            maxPrice: 50,
          ),
        ),
      );

      expect(find.byType(RangeSlider), findsOneWidget);
      expect(find.text('Min : 0.00 Max: 50.00'), findsOneWidget);
    });

    testWidgets('MealIngredientInput widget is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPage(
            searchText: '',
            ingredients: [],
            cooks: [],
            minPrice: 0,
            maxPrice: 50,
          ),
        ),
      );

      expect(find.byType(MealIngredientInput), findsOneWidget);
    });

    // This test requires a way to simulate user input and tap events, which is currently not possible in a unit test.
    // testWidgets('addNewIngredient function adds a new ingredient', (WidgetTester tester) async {
    //   // Your test code here
    // });
  });
}