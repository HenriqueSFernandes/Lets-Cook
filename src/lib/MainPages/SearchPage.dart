import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/NewProductPage/MealIngredientInput.dart';
import 'package:lets_cook/Components/NewProductPage/IngredientCard.dart';

import 'HomePage.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  final List<String> ingredients;
  final List<String> cooks;
  final double minPrice;
  final double maxPrice;

  SearchPage({
    required this.searchText,
    required this.ingredients,
    required this.cooks,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ingredientController = TextEditingController();
  Map<String, IngredientCard> ingredients = {};
  double _minPrice = 0;
  double _maxPrice = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Min : ${_minPrice.toStringAsFixed(2)} Max: ${_maxPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 50,
              divisions: 50,
              onChanged: (RangeValues values) {
                setState(() {
                  _minPrice = double.parse(values.start.toStringAsFixed(2));
                  _maxPrice = double.parse(values.end.toStringAsFixed(2));
                });
              },
            ),
            SizedBox(height: 20),
            MealIngredientInput(ingredientController: ingredientController, addNewIngredient: addNewIngredient),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 20,
              children: ingredients.values
                  .map((e) => Container(
                child: e,
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void addNewIngredient(String name) {
    if (name.isNotEmpty) {
      ingredients[name] = IngredientCard(
        name: name,
        onRemove: () {
          ingredients.remove(name);
          setState(() {});
        },
      );
      ingredientController.clear();
      setState(() {});
    }
  }
}


