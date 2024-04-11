import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_cook/Components/IngredientCard.dart';
import 'package:lets_cook/Components/NewProduct/MealDescriptionInput.dart';
import 'package:lets_cook/Components/NewProduct/MealImageCard.dart';
import 'package:lets_cook/Components/NewProduct/MealIngredientInput.dart';
import 'package:lets_cook/Components/NewProduct/MealNameInput.dart';
import 'package:lets_cook/Components/NewProduct/MealPortionsInput.dart';
import 'package:lets_cook/Components/NewProduct/MealPriceInput.dart';

class NewProductPage extends StatefulWidget {
  NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  Map<String, IngredientCard> ingredients = {};
  Map<String, MealImageCard> images = {};
  File? selectedImage;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final priceController = TextEditingController();
  final portionsController = TextEditingController();

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
      if (selectedImage != null) {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        images[id] = MealImageCard(
            image: selectedImage!,
            onRemove: () {
              images.remove(id);
              setState(() {});
            });
      }
    });
  }

  Future _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(image!.path);
      if (selectedImage != null) {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        images[id] = MealImageCard(
            image: selectedImage!,
            onRemove: () {
              images.remove(id);
              setState(() {});
            });
      }
    });
  }

  void addNewIngredient(String name) {
    if (name.isNotEmpty) {
      ingredients[name] = IngredientCard(
        name: name,
        onRemove: () {
          ingredients.remove(name);
          setState(() {});
        },
      );
      setState(() {});
    }
  }

  Future<List<String>> uploadImages(
      Map<String, MealImageCard> images, String mealID) async {
    final storageRef = FirebaseStorage.instance.ref().child("meals/$mealID");
    List<String> imageUrls = [];
    for (final key in images.keys){
      final file = images[key]!.file;
      final imageRef = storageRef.child("$key.png");
      try {
        await imageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ),
        );
        final url = await imageRef.getDownloadURL();
        print("URL:$url");
        imageUrls.add(url);
      } catch (e) {
        // print only if in debug mode.
        if (kDebugMode) {
          print("Error while uploading the file.");
        }
      }
    }
    return imageUrls;
  }

  void submitMeal() async {
    String name = nameController.text;
    String description = descriptionController.text;
    double? price = double.tryParse(priceController.text);
    int? portions = int.tryParse(portionsController.text);
    List<String> ingredientNames = ingredients.keys.toList();
    List imageFiles = images.values.map((e) => e.file).toList();
    if (name.isEmpty ||
        description.isEmpty ||
        price == null ||
        portions == null ||
        price < 0 ||
        portions <= 0 ||
        ingredientNames.isEmpty ||
        imageFiles.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Invalid data!"),
              content: const Text(
                  "Please check if you entered all the values correctly."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Ok"),
                ),
              ],
            );
          });
      return;
    }

    final String mealID = FirebaseAuth.instance.currentUser!.uid +
        DateTime.now().millisecondsSinceEpoch.toString();
    List<String> imageUrls = await uploadImages(images, mealID);

    final docRef = FirebaseFirestore.instance.collection("dishes").doc(mealID);

    final data = {
      "mealname": name,
      "description": description,
      "price": price,
      "quantity": portions,
      "username": FirebaseAuth.instance.currentUser!.displayName,
      "userid": FirebaseAuth.instance.currentUser!.uid,
      "ingredients": ingredientNames,
      "images": imageUrls,
    };
    await docRef.set(data).onError(
        (error, stackTrace) => print("Error writing document: $error"));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Meal submitted."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ListView(
        children: [
          const Text(
            "What are you cooking today,\nchef?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                MealNameInput(
                  nameController: nameController,
                ),
                const SizedBox(height: 20),
                MealDescriptionInput(
                  descriptionController: descriptionController,
                ),
                const SizedBox(height: 20),
                MealIngredientInput(
                  ingredientController: ingredientController,
                  addNewIngredient: addNewIngredient,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: ingredients.values
                      .map((e) => Container(
                            child: e,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                MealPriceInput(priceController: priceController),
                const SizedBox(height: 20),
                MealPortionsController(portionsController: portionsController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add images:",
                      style: TextStyle(fontSize: 20),
                    ),
                    FilledButton(
                      onPressed: () {
                        _pickImageFromCamera();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text(
                            "Import",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: images.values
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: e,
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Align(
            child: FilledButton(
              onPressed: submitMeal,
              child: const Text(
                "Sell",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
