import 'package:flutter/material.dart';

class MealDescriptionInput extends StatelessWidget {
  final TextEditingController descriptionController;

  const MealDescriptionInput({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Description (200 char max):",
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: const Color(0xFF2F3635),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFFAFDFC),
                  ),
                  onPressed: () => descriptionController.clear(),
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
