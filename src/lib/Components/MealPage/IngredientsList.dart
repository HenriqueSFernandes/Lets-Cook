import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/Extra/CollapsableList.dart';

class IngredientsList extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsList({
    required this.ingredients,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ingredients.sort();
    final splitIngredients = ingredients.slices(3);
    final ingredientsColumn1 = [];
    final ingredientsColumn2 = [];
    final ingredientsColumn3 = [];

    for (var slice in splitIngredients) {
      for (int i = 0; i < slice.length; i++) {
        if (i == 0) {
          ingredientsColumn1.add(slice[i]);
        } else if (i == 1) {
          ingredientsColumn2.add(slice[i]);
        } else if (i == 2) {
          ingredientsColumn3.add(slice[i]);
        }
      }
    }

    return CollapsableList(
      title: "Ingredients",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredientsColumn1.map((e) => Text("• $e")).toList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredientsColumn2.map((e) => Text("• $e")).toList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredientsColumn3.map((e) => Text("• $e")).toList(),
          ),
        ],
      ),
    );
  }
}
