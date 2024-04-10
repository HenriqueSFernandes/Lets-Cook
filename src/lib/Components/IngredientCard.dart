import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String name;
  final Function onRemove;

  const IngredientCard({
    required this.name,
    required this.onRemove,
    super.key,
  });

  String get ingredientName {
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2F3635),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {
                onRemove();
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}
