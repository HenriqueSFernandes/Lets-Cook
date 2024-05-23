import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lets_cook/Components/Extra/CollapsableList.dart';
import 'package:lets_cook/Components/MealPage/NewIngredientCard.dart';
import 'package:lets_cook/Components/NewProductPage/IngredientCard.dart';

class IngredientsList extends StatefulWidget {
  final List<String> ingredients;
  final String mealID;
  final bool isEditable;

  const IngredientsList({
    required this.ingredients,
    required this.mealID,
    this.isEditable = false,
    super.key,
  });

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  TextEditingController ingredientController = TextEditingController();

  Future<void> addIngredient() async {
    final String ingredient = ingredientController.text;
    ingredientController.text = "";
    widget.ingredients.add(ingredient);
    await FirebaseFirestore.instance
        .collection("dishes")
        .doc(widget.mealID)
        .update({"ingredients": widget.ingredients});
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ingredient added",
          ),
        ),
      );
    }
  }

  void removeIngredient(String ingredient) async {
    List<String> newIngredients = [];
    for (String s in widget.ingredients) {
      if (s != ingredient) {
        newIngredients.add(s);
      }
    }
    widget.ingredients.clear();
    for (String s in newIngredients) {
      widget.ingredients.add(s);
    }
    await FirebaseFirestore.instance
        .collection("dishes")
        .doc(widget.mealID)
        .update({"ingredients": newIngredients});
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ingredient removed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.ingredients.sort();
    final ingredientsColumn1 = [];
    final ingredientsColumn2 = [];
    final ingredientsColumn3 = [];
    if (!widget.isEditable) {
      final splitIngredients = widget.ingredients.slices(3);
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
    } else {
      final splitIngredients = widget.ingredients.slices(2);
      for (var slice in splitIngredients) {
        for (int i = 0; i < slice.length; i++) {
          if (i == 0) {
            ingredientsColumn1.add(slice[i]);
          } else if (i == 1) {
            ingredientsColumn2.add(slice[i]);
          }
        }
      }
    }

    return CollapsableList(
      title: "Ingredients",
      child: widget.isEditable
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ingredientsColumn1.map((e) {
                            return Column(
                              children: [
                                IngredientCard(
                                  name: e,
                                  onRemove: () => removeIngredient(e),
                                ),
                                const SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ingredientsColumn2.map((e) {
                            return Column(
                              children: [
                                IngredientCard(
                                  name: e,
                                  onRemove: () => removeIngredient(e),
                                ),
                                const SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => NewIngredientCard(
                      ingredientController: ingredientController,
                      onSubmit: () => addIngredient(),
                    ),
                  ),
                  child: const Text("Add ingredient"),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ingredientsColumn1.map((e) {
                    return Column(
                      children: [
                        IngredientCard(name: e),
                        const SizedBox(height: 5),
                      ],
                    );
                  }).toList(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ingredientsColumn2.map((e) {
                    return Column(
                      children: [
                        IngredientCard(
                          name: e,
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }).toList(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ingredientsColumn3.map((e) {
                    return Column(
                      children: [
                        IngredientCard(
                          name: e,
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
