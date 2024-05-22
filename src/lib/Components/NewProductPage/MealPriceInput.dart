import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealPriceInput extends StatelessWidget {
  final TextEditingController priceController;
  const MealPriceInput({super.key, required this.priceController});

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
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Only accept digits and decimal point
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFFAFDFC),
                  ),
                  onPressed: () => priceController.clear(),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
