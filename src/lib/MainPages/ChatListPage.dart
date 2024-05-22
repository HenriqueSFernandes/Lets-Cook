import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/ChatPage.dart';

class ChatListPage extends StatefulWidget {
  final List<Map<String, dynamic>> rooms;

  ChatListPage({
    required this.rooms,
    super.key,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool hasImage = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> chats = [];
    if (widget.rooms.isNotEmpty) {
      chats = widget.rooms.map(
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
                String userName = snapshot.data![0]["name"];
                String mealName = snapshot.data![1]["mealname"];
                final String imageURL = snapshot.data![0]["image_url"];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageURL == ""
                                  ? const AssetImage(
                                      "lib/resources/default_userimage.png")
                                  : NetworkImage(imageURL) as ImageProvider,
                            ),
                          ),
                        ),
                        Text(
                          "$userName - $mealName",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverID: e["receiverID"],
                            mealID: e["mealID"],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ).toList();
    }
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
