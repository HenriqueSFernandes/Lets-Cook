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
  int characterCount = 0;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.currentValue;
    characterCount = textEditingController.text.length ;
    textEditingController.addListener(_textChangeListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _textChangeListener() {
    setState(() {
      characterCount = textEditingController.text.trim().length;
      updateIsEnabled = textEditingController.text != widget.currentValue;
      if (textEditingController.text.isEmpty) {
        updateIsEnabled = false;
      }
      if(widget.whatToChange == "Name" && textEditingController.text.length > 50){
        updateIsEnabled = false;
      }
      if(widget.whatToChange == "Description" && textEditingController.text.length > 500){
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
          .update({widget.databaseParameterName: textEditingController.text.trim()});
    }
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change ${widget.whatToChange}"),
      content: TextField(
        controller: textEditingController,
        keyboardType: widget.inputType,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          hintText: "Enter the new ${widget.whatToChange}",
          counterText: widget.whatToChange == "Price"
              ? null
              : "$characterCount/${widget.whatToChange == "Name" ? 50 : 500} characters",
          counterStyle: TextStyle(
            color: (widget.whatToChange == "Name" && (characterCount > 50  || characterCount <= 0)) ||
                (widget.whatToChange == "Description" && (characterCount > 500  || characterCount <= 0))
                ? Colors.red
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
