import 'package:flutter/material.dart';
import 'package:lets_cook/Components/NewProduct/IngredientCard.dart';

class MealIngredientInput extends StatelessWidget {
  final TextEditingController ingredientController;
  final Function addNewIngredient;

  const MealIngredientInput({super.key, required this.ingredientController, required this.addNewIngredient});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Ingredients:",
          style: TextStyle(fontSize: 20),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ingredientController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  addNewIngredient(ingredientController.text);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
