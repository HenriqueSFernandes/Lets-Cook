import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String senderUserID;
  final String content;
  final DateTime dateTime;

  const Message({
    super.key,
    required this.senderUserID,
    required this.content,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final bool userIsSender =
        senderUserID == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment:
          userIsSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: userIsSender ? Color(0xFF00514F) : Color(0xFF1B8587),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            content,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
