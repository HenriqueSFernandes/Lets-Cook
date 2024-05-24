import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealPriceInput extends StatefulWidget {
  final TextEditingController priceController;
  const MealPriceInput({super.key, required this.priceController});

  @override
  _MealPriceInputState createState() => _MealPriceInputState();
}

class _MealPriceInputState extends State<MealPriceInput> {
  String? _errorMessage;

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    double? parsedValue = double.tryParse(value);
    if (parsedValue == null || num.parse(parsedValue.toStringAsFixed(2)) <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Price (EUR):",
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
              controller: widget.priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Only accept digits and decimal point
              ],
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _errorMessage = validatePrice(value);
                });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFFAFDFC),
                    ),
                    onPressed: () {
                      widget.priceController.clear();
                      setState(() {
                        _errorMessage = "Please enter a price"; // This will remove the error message
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
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
      ],
    );
  }
}