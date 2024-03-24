import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  String userName;
  String dishName;
  double price;
  static const Color aquaGreen = Color(0xFF1B8587);

  Product(
      {required this.userName,
      required this.dishName,
      required this.price,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 225,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.green,
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
                  color: Colors.green,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0), // Adjusted padding
                  child: Text(
                    "Heading",
                    style: TextStyle(
                      fontSize: 25,
                      color: aquaGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0), // Adjusted padding
                  child: Text(
                    "Paragraph",
                    style: TextStyle(
                      color: aquaGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              width: 30,
                              height: 30,
                              color: aquaGreen,
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5), // Add spacing between star icon and text
                          Text(
                            "4.8", // Convert the rating to string
                            style: TextStyle(
                              fontSize: 20,
                              color: aquaGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "\$$price",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: aquaGreen,
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
