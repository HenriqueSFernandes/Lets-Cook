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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: ListView(
        children: rooms
            .map(
              (e) => GestureDetector(
                child: Text(e["roomID"]!),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                            receiverID: e["receiverID"], mealID: e["mealID"]),
                      ));
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
