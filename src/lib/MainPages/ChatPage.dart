import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/ChatPage/MessageInput.dart';

class Message {
  final String senderUserID;
  final String content;
  final DateTime dateTime;

  Message({
    required this.senderUserID,
    required this.content,
    required this.dateTime,
  });
}

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String mealID;
  final String senderID = FirebaseAuth.instance.currentUser!.uid;
  late String roomID;
  List<Message> messages = [];

  ChatPage({
    required this.receiverID,
    required this.mealID,
    super.key,
  }) {
    final List<String> userIDs = [senderID, receiverID];
    userIDs.sort();
    roomID = userIDs.join() + mealID;
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageInputController = TextEditingController();

  void sendMessage() {
    final String message = messageInputController.text;
    if (message.isEmpty) return;
    final docRef =
        FirebaseFirestore.instance.collection("chatrooms").doc(widget.roomID);
    docRef.update({
      "messages": FieldValue.arrayUnion([
        {
          "content": message,
          "senderID": widget.senderID,
          "datetime": DateTime.now(),
        }
      ])
    });
  }

  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection("chatrooms").doc(widget.roomID);
    docRef.get().then((value) => {
          if (!value.exists)
            {
              docRef.set({
                "user1ID": widget.senderID,
                "user2ID": widget.receiverID,
                "mealID": widget.mealID,
                "messages": [],
              })
            }
        });
    docRef.snapshots().listen((event) {
      List<Message> updatedMessages = [];
      for (var message in event.data()!["messages"]) {
        updatedMessages.add(Message(
          senderUserID: message["senderID"],
          content: message["content"],
          dateTime: message["datetime"].toDate(),
        ));
      }
      if (!mounted) return;
      setState(() {
        widget.messages = updatedMessages;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                children: widget.messages.reversed
                    .map((e) => Row(
                          mainAxisAlignment: e.senderUserID == widget.senderID
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [Text(e.content)],
                        ))
                    .toList(),
              ),
            ),
            MessageInput(
              inputController: messageInputController,
              onSend: sendMessage,
            )
          ],
        ),
      ),
    );
  }
}
