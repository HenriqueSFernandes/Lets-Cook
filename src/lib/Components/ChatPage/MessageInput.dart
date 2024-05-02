import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController inputController;
  final VoidCallback onSend;

  MessageInput({
    required this.inputController,
    super.key,
    required this.onSend,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      //height: 80,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.inputController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onSend();
              widget.inputController.clear();
            },
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
