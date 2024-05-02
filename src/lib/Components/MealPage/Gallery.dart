import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Gallery extends StatefulWidget {
  final List<NetworkImage> images;
  final int initialIndex;

  const Gallery({
    required this.initialIndex,
    required this.images,
    Key? key,
  }) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late PageController pageController;
  bool _zoomEnabled = true;
  bool _scrollEnabled = true;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Listener(
            onPointerDown: (details) {
              _pointerCount++;
              if (_pointerCount > 1) {
                setState(() {
                  _zoomEnabled = true;
                  _scrollEnabled = false;
                });
              }
            },
            onPointerUp: (details) {
              _pointerCount--;
              if (_pointerCount <= 1) {
                setState(() {
                  _zoomEnabled = false;
                  _scrollEnabled = true;
                });
              }
            },
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {});
              },
              physics: _scrollEnabled ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return PhotoView(
                  backgroundDecoration: const BoxDecoration(color: Colors.white),
                  imageProvider: widget.images[index],
                  maxScale: _zoomEnabled ? PhotoViewComputedScale.contained * 2.5 : PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                );
              },
            ),
          ),
          Positioned(
            bottom: 75,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
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
                  Text(
                    "${pageController.hasClients && pageController.page != null ? pageController.page!.round() + 1 : widget.initialIndex + 1}/${widget.images.length}",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
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