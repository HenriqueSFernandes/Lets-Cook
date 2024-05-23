import 'package:flutter/material.dart';

class NewIngredientCard extends StatefulWidget {
  final TextEditingController ingredientController;
  final Function onSubmit;

  const NewIngredientCard({
    required this.ingredientController,
    required this.onSubmit,
    super.key,
  });

  @override
  State<NewIngredientCard> createState() => _NewIngredientCardState();
}

class _NewIngredientCardState extends State<NewIngredientCard> {
  bool uploadIsEnabled = false;
  bool isUploading = false;
  int characterCount = 0;

  @override
  void initState() {
    super.initState();
    widget.ingredientController.addListener(_ingredientChangeListener);
  }

  void _ingredientChangeListener() {
    characterCount = widget.ingredientController.text.trim().length;
    setState(() {
      uploadIsEnabled = widget.ingredientController.text.trim().isNotEmpty && widget.ingredientController.text.trim().length <= 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new ingredient"),
      content: TextField(
        keyboardType: TextInputType.text,
        controller: widget.ingredientController,
        decoration: InputDecoration(
          hintText: "Ingredient",
          counterText: "$characterCount/15 characters",
          counterStyle: TextStyle(
            color: characterCount > 15 ? Colors.red
                : Colors.black,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        isUploading
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: uploadIsEnabled
                    ? () async {
                        await widget.onSubmit();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Ingredient added",
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text("Add"),
              )
      ],
    );
  }
}
