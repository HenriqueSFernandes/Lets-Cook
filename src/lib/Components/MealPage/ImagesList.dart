import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_cook/Components/Extra/CollapsableList.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart';
import 'package:lets_cook/Components/MealPage/ImageCard.dart';

class ImagesList extends StatefulWidget {
  List<String> imageURLs;
  final String mealID;
  final bool isEditable;

  ImagesList({
    required this.imageURLs,
    required this.mealID,
    this.isEditable = false,
    super.key,
  });

  @override
  State<ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  bool isUploading = false;
  File? selectedImage;
  String? id;

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
      if (selectedImage != null) {
        id = DateTime.now().millisecondsSinceEpoch.toString();
      }
    });
  }

  Future _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(image!.path);
      if (selectedImage != null) {
        id = DateTime.now().millisecondsSinceEpoch.toString();
      }
    });
  }

  Future<void> uploadImage(Map<String, File> image) async {
    setState(() {
      isUploading = true;
    });
    final storageRef =
        FirebaseStorage.instance.ref().child("meals/${widget.mealID}");
    final imageRef = storageRef.child("${image.keys.first}.png");
    await imageRef.putFile(
      image.values.first,
      SettableMetadata(contentType: "image/jpeg"),
    );
    final url = await imageRef.getDownloadURL();
    final mealRef =
        FirebaseFirestore.instance.collection("dishes").doc(widget.mealID);
    await mealRef.update({
      "images": FieldValue.arrayUnion([url])
    });
    setState(() {
      widget.imageURLs.add(url);
      isUploading = false;
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Image added",
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CollapsableList(
      title: "Pictures (${widget.imageURLs.length})",
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.imageURLs
                  .mapIndexed((index, image) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Gallery(
                                  initialIndex: index,
                                  imageURLs: widget.imageURLs),
                            ),
                          ),
                          child: ImageCard(imageURL: image),
                        ),
                      ))
                  .toList(),
            ),
          ),
          widget.isEditable
              ? isUploading
                  ? const CircularProgressIndicator()
                  : Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Select image source"),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _pickImageFromGallery();
                                      await uploadImage({id!: selectedImage!});
                                    },
                                    child: const Icon(Icons.image),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _pickImageFromCamera();
                                      await uploadImage({id!: selectedImage!});
                                    },
                                    child:
                                        const Icon(Icons.photo_camera_outlined),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text("Add image"),
                      ),
                    )
              : const SizedBox(),
        ],
      ),
    );
  }
}
