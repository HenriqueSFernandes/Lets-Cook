import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final String userName;
  final String dishName;
  final double price;
  final String documentRef;

  Product(
      {required this.userName,
      required this.dishName,
      required this.price,
      required this.documentRef,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: 300,
      height: 225,
      margin: const EdgeInsets.all(10),
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
        image: const DecorationImage(
          image: AssetImage("lib/resources/francesinha.jpg"),
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
              borderRadius: BorderRadius.only(
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
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          // Add spacing between star icon and text
                          Text(
                            "4.8", // Convert the rating to string
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
    );
  }
}
