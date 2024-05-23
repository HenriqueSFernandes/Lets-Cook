import 'package:flutter/material.dart';
import 'package:lets_cook/Components/NewProductPage/IngredientCard.dart';

class MealIngredientInput extends StatefulWidget {
  final Function addNewIngredient;
  final TextEditingController ingredientController;

  const MealIngredientInput({super.key, required this.ingredientController, required this.addNewIngredient});

  @override
  _MealIngredientInputState createState() => _MealIngredientInputState();
}

class _MealIngredientInputState extends State<MealIngredientInput> {
  String? _errorMessage;

  String? validateIngredient(String? value) {
    value = value?.trim(); // Trim the input string
    if (value!.length > 15) {
      return 'Ingredient name cannot be more than 15 characters';
    }
    return null;
  }

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
              color: _errorMessage != null ? Colors.red : Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.ingredientController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = validateIngredient(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_errorMessage == null) {
                    if(widget.ingredientController.text.trim().isNotEmpty) {
                      widget.addNewIngredient(
                          widget.ingredientController.text.trim());
                    }
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
      ],
    );
  }
}