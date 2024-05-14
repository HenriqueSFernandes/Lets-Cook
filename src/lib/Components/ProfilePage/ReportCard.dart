import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatefulWidget {
  final String userID;
  final String username;

  const ReportCard({
    required this.userID,
    required this.username,
    super.key,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  late TextEditingController textEditingController;
  bool reportIsEnabled = false;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(_textChangeListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _textChangeListener() {
    setState(() {
      reportIsEnabled = textEditingController.text.isNotEmpty;
    });
  }

  void sendReport() async {
    setState(() {
      isUploading = true;
    });
    final String docName =
        widget.userID + DateTime.now().millisecondsSinceEpoch.toString();
    final reportRef =
        FirebaseFirestore.instance.collection("reports").doc(docName);
    await reportRef.set({
      "username": widget.username,
      "userID": widget.userID,
      "reporterName": FirebaseAuth.instance.currentUser!.displayName,
      "reporterID": FirebaseAuth.instance.currentUser!.uid,
      "date": DateTime.now(),
      "reason": textEditingController.text,
    });
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Why do you wish do report ${widget.username}?"),
      content: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 500,
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: "Reason",
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
                onPressed: reportIsEnabled
                    ? () {
                        sendReport();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Report submitted"),
                          ),
                        );
                      }
                    : null,
                child: const Text("Report"),
              ),
      ],
    );
  }
}
