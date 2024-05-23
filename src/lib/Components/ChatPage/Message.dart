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
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: userIsSender ? const Color(0xFF00514F) : const Color(0xFF1B8587),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            margin : userIsSender ?  const EdgeInsets.only(bottom: 10, right: 10, left: 60) : const EdgeInsets.only(bottom: 10, left: 10, right: 60),
          
            child: Text(
              content,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
