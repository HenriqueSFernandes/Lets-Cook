import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/HomePage/MealCard.dart';
import 'package:lets_cook/Components/ProfilePage/RateCard.dart';
import 'package:lets_cook/Components/ProfilePage/ReportCard.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  final void Function(int)? setIndex;

  ProfilePage({
    required this.userID,
    this.setIndex,
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
bool hasPreviousRoute(BuildContext context) {
  return ModalRoute.of(context)?.canPop ?? false;
}


class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>> getUserInfo() async {
    Map<String, dynamic> info = {};
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    await userRef.get().then(
      (value) {
        info['name'] = value['name'];
        info['bio'] = value['more_about_yourself'];
        info['image_url'] = value['image_url'];
        if (value.data()!.containsKey('totalRating') &&
            value.data()!.containsKey('ratingCount')) {
          info['rating'] = (value['totalRating'] / value['ratingCount']);
        } else {
          info['rating'] = 0.0;
        }
      },
    );
    return info;
  }

  Future<Map<String, dynamic>> getProductsAndInfo() async {
    final info = await getUserInfo();
    List<MealCard> products = [];
    final dishesRef = FirebaseFirestore.instance.collection("dishes");
    final userDishesRef = dishesRef.where('userid', isEqualTo: widget.userID);
    final data = await userDishesRef.get();
    for (var value in data.docs) {
      products.add(MealCard(
        userName: value['username'],
        dishName: value['mealname'],
        price: value['price'],
        description: value['description'],
        userID: value['userid'],
        mealID: value.id,
        imageURLs: List<String>.from(value["images"]),
        ingredients: List<String>.from(value["ingredients"]),
        setIndex: widget.setIndex,
        rating: info['rating'],
      ));
    }
    return {'info': info, 'products': products};
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        widget.userID == FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: FutureBuilder(
        future: getProductsAndInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<MealCard> products = snapshot.data!['products'];
              Map<String, dynamic> info = snapshot.data!['info'];
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
                            info['rating'] == 0
                                ? "N/A"
                                : "${info['rating'].toStringAsFixed(1)} / 5.0",
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !isCurrentUser
                                  ? ElevatedButton(
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => RateCard(
                                              userID: widget.userID,
                                              userName: info['name']!)),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                      child: const Text(
                                        "Rate",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              SizedBox(width: isCurrentUser ? 0 : 20),
                              ElevatedButton(
                                onPressed: () async {
                                  if (isCurrentUser) {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushNamed(context, '/sign-in');
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ReportCard(
                                            userID: widget.userID,
                                            username: info['name']!,
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
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if(hasPreviousRoute(context))
                  Positioned(
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
