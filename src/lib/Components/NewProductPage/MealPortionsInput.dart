import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealPortionsController extends StatefulWidget {
  final TextEditingController portionsController;

  const MealPortionsController({super.key, required this.portionsController});

  @override
  _MealPortionsControllerState createState() => _MealPortionsControllerState();
}

class _MealPortionsControllerState extends State<MealPortionsController> {
  String? _errorMessage;

  String? validatePortions(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number of portions';
    }
    int? parsedValue = int.tryParse(value);
    if (parsedValue == null || parsedValue <= 0) {
      return 'Number of portions must be greater than 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Number of portions:",
          style: TextStyle(fontSize: 20),
        ),
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: widget.portionsController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _errorMessage = validatePortions(value);
                });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFFAFDFC),
                  ),
                  onPressed: () {
                    widget.portionsController.clear();
                    setState(() {
                      _errorMessage = "Please enter a number of portions"; // This will remove the error message
                    });
                  },
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
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
      ],
    );
  }
}