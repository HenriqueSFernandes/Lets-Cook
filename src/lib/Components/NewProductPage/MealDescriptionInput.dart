import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealDescriptionInput extends StatefulWidget {
  final TextEditingController descriptionController;

  const MealDescriptionInput({Key? key, required this.descriptionController}) : super(key: key);

  @override
  _MealDescriptionInputState createState() => _MealDescriptionInputState();
}

class _MealDescriptionInputState extends State<MealDescriptionInput> {
  String? _errorMessage;
  int _charCount = 0;

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    if (value.length > 500) {
      return 'Description cannot be more than 500 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Description:",
          style: TextStyle(fontSize: 20),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            border: Border(
              bottom: BorderSide(
                width: 4,
                color: _errorMessage != null ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: widget.descriptionController,
                    onChanged: (value) {
                      setState(() {
                        _charCount = value.length;
                        _errorMessage = validateDescription(value);
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.descriptionController.clear();
                    setState(() {
                      _errorMessage = "Please enter a description"; // This will remove the error message
                      _charCount = 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _charCount == 0
              ? Container() // Return an empty Container when character count is 0
              : Text(
            '$_charCount/50 characters',
            style: TextStyle(
              fontSize: 15,
              color: _charCount > 500 ? Colors.red : null, // Make the text red when character count exceeds 50
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