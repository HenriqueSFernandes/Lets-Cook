import 'package:flutter/material.dart';

class MealNameInput extends StatefulWidget {

  final TextEditingController nameController;

  const MealNameInput({super.key, required this.nameController});


  @override
  _MealNameInputState createState() => _MealNameInputState();
}


class _MealNameInputState extends State<MealNameInput> {
  String? _errorMessage;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a meal name';
    }
    if (value.length > 20) {
      return 'Meal name cannot be more than 20 characters';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Meal name (20 char max):",
          style: TextStyle(fontSize: 20),
        ),
        Container(
          /*
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            border: Border(
              bottom: BorderSide(
                width: 4,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          */
          decoration: _errorMessage == null
              ? BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            border: Border(
              bottom: BorderSide(
                width: 4,
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          )
              : BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            border: Border.all(
              color: Colors.red, // Full border when there is an error
              width: 4,
            ),
            color: const Color(0xFF2F3635),
          ),
          //border ends here
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Color(0xFFFAFDFC)),
              controller: widget.nameController,
              onChanged: (value) {
                setState(() {
                  _errorMessage = validateName(value);
                });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                    onPressed: () {
                      widget.nameController.clear();
                      setState(() {
                        _errorMessage = null; // This will remove the error message
                      });
                    }
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}