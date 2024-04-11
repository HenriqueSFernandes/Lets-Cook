import 'package:flutter/material.dart';

class MealPortionsController extends StatelessWidget {
  final TextEditingController portionsController;

  const MealPortionsController({super.key, required this.portionsController});

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
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: portionsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFFAFDFC),
                  ),
                  onPressed: () => portionsController.clear(),
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
