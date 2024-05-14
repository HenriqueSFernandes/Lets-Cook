import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateValueDialog extends StatefulWidget {
  final String mealID;
  final String whatToChange;
  final String currentValue;
  final String databaseParameterName;
  final TextInputType inputType;
  final int? maxLines;
  final bool isList;

  const UpdateValueDialog({
    required this.mealID,
    required this.whatToChange,
    required this.currentValue,
    required this.databaseParameterName,
    this.inputType = TextInputType.text,
    this.maxLines,
    this.isList = false,
    super.key,
  });

  @override
  State<UpdateValueDialog> createState() => _UpdateValueDialogState();
}

class _UpdateValueDialogState extends State<UpdateValueDialog> {
  late TextEditingController textEditingController;
  bool updateIsEnabled = false;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.currentValue;
    textEditingController.addListener(_textChangeListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _textChangeListener() {
    setState(() {
      updateIsEnabled = textEditingController.text != widget.currentValue;
      if (textEditingController.text.isEmpty) {
        updateIsEnabled = false;
      }
      if (widget.inputType == TextInputType.number) {
        double? price = double.tryParse(textEditingController.text);
        if (price == null) {
          updateIsEnabled = false;
        } else if (price < 0) {
          updateIsEnabled = false;
        }
      }
    });
  }

  Future<void> update() async {
    setState(() {
      isUploading = true;
    });
    final docRef =
        FirebaseFirestore.instance.collection("dishes").doc(widget.mealID);
    if (widget.inputType == TextInputType.number) {
      double? price = double.tryParse(textEditingController.text);
      await docRef.update({widget.databaseParameterName: price});
    } else {
      await docRef
          .update({widget.databaseParameterName: textEditingController.text});
    }
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change name"),
      content: TextField(
        controller: textEditingController,
        keyboardType: widget.inputType,
        maxLines: widget.maxLines,
        decoration: const InputDecoration(
          hintText: "Enter the new name",
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
                onPressed: updateIsEnabled
                    ? () async {
                        await update();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Meal updated",
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text("Update"),
              ),
      ],
    );
  }
}
