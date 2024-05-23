import 'package:flutter/material.dart';

class MealNameInput extends StatelessWidget {

  final TextEditingController nameController;

  const MealNameInput({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Meal name (20 char max):",
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
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Color(0xFFFAFDFC)),
              controller: nameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => nameController.clear(),
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
