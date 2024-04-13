import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/Product/ProductCard.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    final collectionRef = db.collection("dishes");
    collectionRef.snapshots().listen(
      (event) {
        List<Product> updatedProducts = [];
        for (var element in event.docs) {
          updatedProducts.add(Product(
            userName: element["username"],
            dishName: element["mealname"],
            price: element["price"],
            description: element["description"],
            imageURL: element["images"][0],
            ingredients: List<String>.from(element["ingredients"]),
          ));
        }
        if (!mounted) return;
        setState(() {
          products = updatedProducts;
        });
      },
      onError: (error) => print("Listen failed: $error"),
    );
    return ListView(
      children: products,
      padding: EdgeInsets.only(left: 15, right: 15),
    );
  }
}
