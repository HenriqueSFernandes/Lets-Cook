import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/ChatPage/Message.dart';
import 'package:lets_cook/Components/ChatPage/MessageInput.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String mealID;
  final String senderID = FirebaseAuth.instance.currentUser!.uid;
  String? roomID;
  String? chefName;
  String? mealName;
  List<Message> messages = [];

  ChatPage({
    required this.receiverID,
    required this.mealID,
    super.key,
  }) {
    final List<String> userIDs = [senderID, receiverID];
    userIDs.sort();
    roomID = userIDs.join() + mealID;
    final mealRef = FirebaseFirestore.instance.collection("dishes").doc(mealID);
    mealRef.get().then((value) => {
          chefName = value["username"],
          mealName = value["mealname"],
        });
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
    docRef.get().then((value) {
      if (!value.exists) {
        docRef.set({
          "user1ID": widget.senderID,
          "user2ID": widget.receiverID,
          "mealID": widget.mealID,
          "messages": [],
        });
        final senderRef =
            FirebaseFirestore.instance.collection("users").doc(widget.senderID);
        final receiverRef = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.receiverID);
        senderRef.update({
          "chatrooms": FieldValue.arrayUnion([
            {
              "roomID": widget.roomID,
              "receiverID": widget.receiverID,
              "mealID": widget.mealID,
            },
          ])
        });
        receiverRef.update({
          "chatrooms": FieldValue.arrayUnion([
            {
              "roomID": widget.roomID,
              "receiverID": widget.senderID,
              "mealID": widget.mealID,
            }
          ])
        });
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.mealName ?? ""),
            Text(
              widget.chefName ?? "",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "See details",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                children: widget.messages.reversed.toList(),
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
