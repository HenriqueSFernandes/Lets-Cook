import 'package:flutter/material.dart';
import 'package:lets_cook/Product/Product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) =>
            Product(dishName: "Francesinha", price: 5.99, userName: "Username"),
      ),
    );
  }
}