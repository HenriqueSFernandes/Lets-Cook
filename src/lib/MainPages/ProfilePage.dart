import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/HomePage/ProductCard.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  ProfilePage({
    required this.userID,
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<List<Product>> getProducts() async {
    List<Product> products = [];
    final dishesRef = FirebaseFirestore.instance.collection("dishes");
    final userDishesRef = dishesRef.where('userid',
        isEqualTo: widget.userID);
    await userDishesRef.get().then((doc) {
      for (var value in doc.docs) {
        products.add(Product(
          userName: value['username'],
          dishName: value['mealname'],
          price: value['price'],
          description: value['description'],
          userID: value['userid'],
          mealID: value.id,
          imageURLs: List<String>.from(value["images"]),
          ingredients: List<String>.from(value["ingredients"]),
        ));
      }
    });
    return products;
  }

  Future<Map<String, String>> getUserInfo() async {
    Map<String, String> info = {};
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    await userRef.get().then(
      (value) {
        info['name'] = value['name'];
        info['bio'] = value['more_about_yourself'];
        info['image_url'] = value['image_url'];
      },
    );
    return info;
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        widget.userID == FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([getUserInfo(), getProducts()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Product> products = snapshot.data![1] as List<Product>;
              Map<String, String> info =
                  snapshot.data![0] as Map<String, String>;
              return Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(info['image_url']!),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Text(
                        info['name']!,
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
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(info['bio']!),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Available meals:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: products,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isCurrentUser) {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushNamed(context, '/sign-in');
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Feature not implemented!"),
                                        content: const Text(
                                            "The report system will be available as soon as possible."),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Ok"),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            child: Text(
                              isCurrentUser ? "Sign-out" : "Report",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  isCurrentUser ? const SizedBox() : Positioned(
                    top: 40,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(5),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
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
    );
  }
}
