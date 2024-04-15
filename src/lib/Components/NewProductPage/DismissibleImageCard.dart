import 'dart:io';

import 'package:flutter/material.dart';

class DismissibleImageCard extends StatelessWidget {
  final Function onRemove;
  final File image;

  const DismissibleImageCard({required this.image, required this.onRemove, super.key});

  File get file {
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              fit: BoxFit.cover,
              image: FileImage(image),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              onRemove();
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
