import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/ChatPage.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  Future<Map<dynamic, dynamic>> getInfo(String userID, String mealID) async {
    final userRef = FirebaseFirestore.instance.collection("users").doc(userID);
    final user = await userRef.get();
    final mealRef = FirebaseFirestore.instance.collection("dishes").doc(mealID);
    final meal = await mealRef.get();
    return {
      "name": user['name'],
      "image_url": user['image_url'],
      "mealname": meal['mealname'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final List? data = snapshot.data!.data()!['chatrooms'];
            if (data == null || data.isEmpty) {
              return const Center(
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
              );
            }
            return ListView(
              children: data
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          child: FutureBuilder(
                            future: getInfo(e["receiverID"], e['mealID']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Row(
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: snapshot
                                                        .data!['image_url'] ==
                                                    ""
                                                ? const AssetImage(
                                                    "lib/resources/default_userimage.png")
                                                : CachedNetworkImageProvider(
                                                    snapshot.data!['image_url'],
                                                    errorListener: (p0) =>
                                                        const Text("Loading"),
                                                  ) as ImageProvider,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${snapshot.data!["name"]} - ${snapshot.data!["mealname"]}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
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
                      ))
                  .toList(),
            );
          }
        }
        print(snapshot);
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
