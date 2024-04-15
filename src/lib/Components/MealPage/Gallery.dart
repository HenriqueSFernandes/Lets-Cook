import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Gallery extends StatefulWidget {
  final List<NetworkImage> images;
  final int initialIndex;

  const Gallery({
    required this.initialIndex,
    required this.images,
    super.key,
  });

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late int currentIndex = widget.initialIndex;

  void nextImage() {
    currentIndex++;
    if (currentIndex >= widget.images.length) {
      currentIndex = 0;
    }
    setState(() {});
  }

  void previousImage() {
    currentIndex--;
    if (currentIndex < 0) {
      currentIndex = widget.images.length - 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
          ),
          PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: widget.images[currentIndex],
            maxScale: PhotoViewComputedScale.contained * 2.5,
            minScale: PhotoViewComputedScale.contained,
          ),
          const SizedBox(height: 20),
          Positioned(
            bottom: 75,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      previousImage();
                    },
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
                  const SizedBox(width: 10),
                  Text(
                    "${currentIndex + 1}/${widget.images.length}",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: nextImage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
