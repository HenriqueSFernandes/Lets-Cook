import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final NetworkImage image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          fit: BoxFit.cover,
          image: image,
        ),
      ),
    );
  }
}
