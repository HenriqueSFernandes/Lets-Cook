import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart';
import 'package:lets_cook/Components/MealPage/ImagesList.dart';
import 'package:lets_cook/Components/MealPage/IngredientsList.dart';
import 'package:lets_cook/Components/MealPage/UpdateValueDialog.dart';
import 'package:lets_cook/Components/MealPage/UserButton.dart';
import 'package:lets_cook/MainPages/ChatPage.dart';
import 'package:lets_cook/MainPages/HomePage.dart';

class MealPage extends StatefulWidget {
  final String userName;
  String dishName;
  double price;
  String description;
  final String userID;
  final String mealID;
  final List<String> imageURLs;
  final List<String> ingredients;
  final void Function(int)? setIndex;
  final double rating;

  MealPage({
    super.key,
    required this.userName,
    required this.dishName,
    required this.price,
    required this.description,
    required this.userID,
    required this.mealID,
    required this.imageURLs,
    required this.ingredients,
    required this.rating,
    this.setIndex,
  });

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  bool isDeleting = false;

  void refreshPage() async {
    final mealRef =
        FirebaseFirestore.instance.collection("dishes").doc(widget.mealID);
    await mealRef.get().then((value) {
      widget.dishName = value['mealname'];
      widget.price = double.parse(value["price"].toString());
      widget.description = value['description'];
      widget.ingredients.clear();
      for (String s in value['ingredients']) {
        widget.ingredients.add(s);
      }
    });
    setState(() {});
  }

  Future<void> deleteMeal() async {
    setState(() {
      isDeleting = true;
    });
    final mealRef =
        FirebaseFirestore.instance.collection("dishes").doc(widget.mealID);
    await mealRef.delete();
    final chatRooms = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("mealID", isEqualTo: widget.mealID)
        .get();
    final List<String> userIds = [];
    for (QueryDocumentSnapshot chatRoom in chatRooms.docs) {
      userIds.add(chatRoom['user1ID']);
      userIds.add(chatRoom['user2ID']);
      await chatRoom.reference.delete();
    }
    for (String userId in userIds) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      List chatRooms = userDocSnapshot['chatrooms'];
      List newChatRooms = [];
      for (var chatroom in chatRooms) {
        if (chatroom['mealID'] != widget.mealID) {
          newChatRooms.add(chatroom);
        }
      }
      await userDocRef.update({"chatrooms": newChatRooms});
    }
    final storageRef =
        FirebaseStorage.instance.ref().child("meals/${widget.mealID}");
    await storageRef.listAll().then((value) async {
      for (Reference ref in value.items) {
        await ref.delete();
      }
    });

    setState(() {
      isDeleting = false;
    });
  }

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
                        Gallery(initialIndex: 0, imageURLs: widget.imageURLs),
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.imageURLs[0],
                        errorListener: (p0) {
                          const Text('Loading');
                        },
                      ),
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
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          widget.dishName,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      chefIsCurrentUser
                                          ? IconButton(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return UpdateValueDialog(
                                                      mealID: widget.mealID,
                                                      whatToChange: "Name",
                                                      currentValue:
                                                          widget.dishName,
                                                      databaseParameterName:
                                                          'mealname',
                                                    );
                                                  },
                                                );
                                                refreshPage();
                                              },
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
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${widget.price.toStringAsFixed(2)}€",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    chefIsCurrentUser
                                        ? IconButton(
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    UpdateValueDialog(
                                                  mealID: widget.mealID,
                                                  whatToChange: "Price",
                                                  currentValue:
                                                      widget.price.toString(),
                                                  databaseParameterName:
                                                      "price",
                                                  inputType:
                                                      TextInputType.number,
                                                ),
                                              );
                                              refreshPage();
                                            },
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
                                      widget.rating == 0
                                          ? "N/A"
                                          : "${widget.rating} / 5.0",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Text(widget.description)),
                                chefIsCurrentUser
                                    ? IconButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                UpdateValueDialog(
                                              mealID: widget.mealID,
                                              whatToChange: "Description",
                                              currentValue: widget.description,
                                              databaseParameterName:
                                                  "description",
                                              inputType:
                                                  TextInputType.multiline,
                                            ),
                                          );
                                          refreshPage();
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        iconSize: 30,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            IngredientsList(
                              ingredients: widget.ingredients,
                              mealID: widget.mealID,
                              isEditable: chefIsCurrentUser,
                            ),
                            ImagesList(
                              imageURLs: widget.imageURLs,
                              mealID: widget.mealID,
                              isEditable: chefIsCurrentUser,
                            ),
                            chefIsCurrentUser
                                ? Center(
                                    child: ElevatedButton(
                                        onPressed: () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Are you sure you want to delete the meal?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await deleteMeal();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .clearSnackBars();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Meal deleted"),
                                                        ),
                                                      );
                                                      if (widget.setIndex !=
                                                          null) {
                                                        widget.setIndex!(0);
                                                      }
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              "/home",
                                                              (route) => false);
                                                    },
                                                    child: const Text("Yes"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        )),
                                  )
                                : const SizedBox(),
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
