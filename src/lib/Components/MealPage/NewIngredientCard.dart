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

  @override
  void initState() {
    super.initState();
    widget.ingredientController.addListener(_ingredientChangeListener);
  }

  void _ingredientChangeListener() {
    setState(() {
      uploadIsEnabled = widget.ingredientController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new ingredient"),
      content: TextField(
        keyboardType: TextInputType.text,
        controller: widget.ingredientController,
        decoration: const InputDecoration(
          hintText: "Ingredient",
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
