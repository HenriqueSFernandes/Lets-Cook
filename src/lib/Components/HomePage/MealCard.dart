import 'package:flutter/material.dart';

import '../../MainPages/MealPage.dart';

class MealCard extends StatelessWidget {
  final String userName;
  final String dishName;
  final double price;
  final String description;
  final String userID;
  final String mealID;
  final List<String> imageURLs;
  final List<String> ingredients;
  final double rating;
  final void Function(int)? setIndex;

  const MealCard({
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        List<NetworkImage> images =
            imageURLs.map((e) => NetworkImage(e)).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPage(
              userName: userName,
              dishName: dishName,
              price: price,
              description: description,
              userID: userID,
              mealID: mealID,
              images: images,
              ingredients: ingredients,
              setIndex: setIndex,
              rating: rating,
            ),
          ),
        );
      },
      child: Container(
        height: 225,
        margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(4, 4),
            )
          ],
          image: DecorationImage(
            image: NetworkImage(imageURLs[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(9),
                    bottomRight: Radius.circular(9)),
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0.0), // Adjusted padding
                    child: Text(
                      dishName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0.0), // Adjusted padding
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 2.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                width: 30,
                                height: 30,
                                color: primaryColor,
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // Add spacing between star icon and text
                            Text(
                              rating == 0
                                  ? "N/A"
                                  : rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 20,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "${price.toStringAsFixed(2)}€",
                          style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
