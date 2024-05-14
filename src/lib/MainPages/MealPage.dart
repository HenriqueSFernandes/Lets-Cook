import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart';
import 'package:lets_cook/Components/MealPage/ImagesList.dart';
import 'package:lets_cook/Components/MealPage/IngredientsList.dart';
import 'package:lets_cook/Components/MealPage/UserButton.dart';
import 'package:lets_cook/MainPages/ChatPage.dart';

class MealPage extends StatefulWidget {
  final String userName;
  final String dishName;
  final double price;
  final String description;
  final String userID;
  final String mealID;
  final List<NetworkImage> images;
  final List<String> ingredients;

  const MealPage({
    super.key,
    required this.userName,
    required this.dishName,
    required this.price,
    required this.description,
    required this.userID,
    required this.mealID,
    required this.images,
    required this.ingredients,
  });

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    bool chefIsCurrentUser =
        widget.userID == FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Gallery(initialIndex: 0, images: widget.images),
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.images[0],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 1),
                  child: Scrollbar(
                    radius: const Radius.circular(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.dishName,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    chefIsCurrentUser
                                        ? IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            iconSize: 30,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Text(
                                  "${widget.price.toStringAsFixed(2)}€",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                UserButton(
                                  userName: widget.userName,
                                  userID: widget.userID,
                                  mealID: widget.mealID,
                                ),
                                Row(
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
                                    // Add spacing between star icon and text
                                    Text(
                                      "4.8 / 5.0",
                                      // Convert the rating to string
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(widget.description),
                            IngredientsList(ingredients: widget.ingredients),
                            ImagesList(images: widget.images),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          chefIsCurrentUser
              ? const SizedBox()
              : Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                            receiverID: widget.userID, mealID: widget.mealID),
                      ));
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(
                          left: 35,
                          right: 35,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      "BUY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
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
      ),
    );
  }
}
