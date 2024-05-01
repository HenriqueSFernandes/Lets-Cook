import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/ChatPage.dart';

class ChatListPage extends StatelessWidget {
  final List<Map<String, dynamic>> rooms;

  const ChatListPage({
    required this.rooms,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final chats = rooms.map(
      (e) {
        String receiverID = e["receiverID"];
        String mealID = e["mealID"];
        final userRef =
            FirebaseFirestore.instance.collection("users").doc(receiverID);
        final mealRef =
            FirebaseFirestore.instance.collection("dishes").doc(mealID);
        return FutureBuilder(
          future: Future.wait([userRef.get(), mealRef.get()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String userName = snapshot.data![0]["username"];
              String mealName = snapshot.data![1]["mealname"];
              return GestureDetector(
                child: Row(
                  children: [
                    Text(mealName),
                    Text(userName),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                            receiverID: e["receiverID"], mealID: e["mealID"]),
                      ));
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: chats.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "(·_·)",
                    style: TextStyle(fontSize: 64),
                  ),
                  Text(
                    "It's a little quiet around here...",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView(
              children: chats,
            ),
    );
  }
}
