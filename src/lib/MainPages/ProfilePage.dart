import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  ProfilePage({
    required this.userID,
    required super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String bio = "";

  Future<String> getBio() async {
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    final snapshot = await userRef.get();
    final bio = snapshot.data()!["more_about_yourself"];
    return bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    FirebaseAuth.instance.currentUser!.photoURL as String),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.displayName as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 30,
                  height: 30,
                  color: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "4.8 / 5.0",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: FutureBuilder(
              future: getBio(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data as String);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "extra info here...",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            "Available meals:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {

            },
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  "Sign out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
