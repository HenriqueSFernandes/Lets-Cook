import 'package:flutter/material.dart';

class MealDescriptionInput extends StatefulWidget {
  final TextEditingController descriptionController;

  const MealDescriptionInput({Key? key, required this.descriptionController}) : super(key: key);

  @override
  _MealDescriptionInputState createState() => _MealDescriptionInputState();
}

class _MealDescriptionInputState extends State<MealDescriptionInput> {
  String? _errorMessage;

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    if (value.length > 200) {
      return 'Description cannot be more than 200 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Description (200 char max):",
          style: TextStyle(fontSize: 20),
        ),
        Container(
          /* No error border
          height: 200,
          decoration: BoxDecoration(
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
          ),
          */
          height: 200,
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
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: widget.descriptionController,
              onChanged: (value) {
                setState(() {
                  _errorMessage = validateDescription(value);
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.descriptionController.clear();
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