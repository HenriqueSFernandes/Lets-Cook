import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/ChatPage/Message.dart';
import 'package:lets_cook/Components/ChatPage/MessageInput.dart';
import 'package:lets_cook/MainPages/MealPage.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String mealID;
  final String senderID = FirebaseAuth.instance.currentUser!.uid;
  String? roomID;
  String? chefName;
  String? mealName;
  double? price;
  String? description;
  String? chefID;
  List<String>? ingredients;
  List<NetworkImage>? images;
  double? rating;
  List<Message> messages = [];

  ChatPage({
    required this.receiverID,
    required this.mealID,
    super.key,
  }) {
    Future<double> getMealRating(String userID) async {
      final userRef =
          FirebaseFirestore.instance.collection("users").doc(userID);
      final user = await userRef.get();
      if (user.data()!.containsKey('totalRating') &&
          user.data()!.containsKey('ratingCount')) {
        return (user['totalRating'] / user['ratingCount']);
      } else {
        return 0.0;
      }
    }

    final List<String> userIDs = [senderID, receiverID];
    userIDs.sort();
    roomID = userIDs.join() + mealID;
    final mealRef = FirebaseFirestore.instance.collection("dishes").doc(mealID);
    List<String> imageURLs;
    getMealRating(receiverID).then((rating) => mealRef.get().then((value) => {
          chefName = value["username"],
          mealName = value["mealname"],
          price = value["price"],
          description = value["description"],
          imageURLs = List<String>.from(value["images"]),
          images = imageURLs.map((e) => NetworkImage(e)).toList(),
          chefID = value["userid"],
          ingredients = List<String>.from(value["ingredients"]),
          this.rating = rating,
        }));
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealPage(
                    userName: widget.chefName!,
                    dishName: widget.mealName!,
                    price: widget.price!,
                    description: widget.description!,
                    userID: widget.chefID!,
                    mealID: widget.mealID,
                    images: widget.images!,
                    ingredients: widget.ingredients!,
                    rating: widget.rating!,
                  ),
                ),
              );
            },
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
        padding: const EdgeInsets.all(20),
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
