import 'package:flutter/material.dart';

import 'Username.dart';

class Product extends StatelessWidget {
  String userName;
  String dishName;
  double price;

  Product({required this.userName, required this.dishName, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
        image: const DecorationImage(
          image: AssetImage("lib/resources/francesinha.jpg"),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UserWidget(userName),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dishName,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  "$price€",
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
