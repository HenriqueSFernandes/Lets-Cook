import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/Extra/CollapsableList.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart';
import 'package:lets_cook/Components/MealPage/ImageCard.dart';

class ImagesList extends StatelessWidget {
  final List<NetworkImage> images;

  const ImagesList({
    required this.images,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsableList(
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
                              initialIndex: index, images: images),
                        ),
                      ),
                      child: ImageCard(image: image),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
