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
  int _charCount = 0;

  String? validateIngredient(String? value) {
    value = value?.trim(); // Trim the input string
    if (value!.length > 20) {
      return 'Ingredient name cannot be more than 20 characters';
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
                      _charCount = value.length;
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
                      _charCount = 0;

                    }
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _charCount == 0
              ? Container() // Return an empty Container when character count is 0
              : Text(
            '$_charCount/20 characters',
            style: TextStyle(
              fontSize: 15,
              color: _charCount > 20 ? Colors.red : null, // Make the text red when character count exceeds 50
            ),
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