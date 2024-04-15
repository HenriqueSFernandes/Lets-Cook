import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/MealPage/CollapsableList.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart';
import 'package:lets_cook/Components/MealPage/ImageCard.dart';
import 'package:lets_cook/Components/MealPage/UserButton.dart';

class MealPage extends StatelessWidget {
  final String userName;
  final String dishName;
  final double price;
  final String description;
  final String userID;
  final List<NetworkImage> images;
  final List<String> ingredients;

  const MealPage({
    super.key,
    required this.userName,
    required this.dishName,
    required this.price,
    required this.description,
    required this.userID,
    required this.images,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    ingredients.sort();
    final splitIngredients = ingredients.slices(3);
    final ingredientsColumn1 = [];
    final ingredientsColumn2 = [];
    final ingredientsColumn3 = [];

    for (var slice in splitIngredients) {
      for (int i = 0; i < slice.length; i++) {
        if (i == 0) {
          ingredientsColumn1.add(slice[i]);
        } else if (i == 1) {
          ingredientsColumn2.add(slice[i]);
        } else if (i == 2) {
          ingredientsColumn3.add(slice[i]);
        }
      }
    }

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
                        Gallery(initialIndex: 0, images: images),
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: images[0],
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
                                Text(
                                  dishName,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${price.toStringAsFixed(2)}€",
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
                                  userName: userName,
                                  userID: userID,
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
                            Text(description),
                            CollapsableList(
                              title: "Ingredients",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: ingredientsColumn1
                                        .map((e) => Text("• $e"))
                                        .toList(),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: ingredientsColumn2
                                        .map((e) => Text("• $e"))
                                        .toList(),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: ingredientsColumn3
                                        .map((e) => Text("• $e"))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            CollapsableList(
                              title: "Pictures (${images.length})",
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: images
                                      .mapIndexed((index, image) => Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Gallery(
                                                      initialIndex: index,
                                                      images: images),
                                                ),
                                              ),
                                              child: ImageCard(image: image),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
