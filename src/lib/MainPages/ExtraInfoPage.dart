import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_cook/Components/NewProductPage/DismissibleImageCard.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/main.dart';
import 'package:http/http.dart' as http;

var done=false;

class ExtraInfoPage extends StatefulWidget {
  ExtraInfoPage({Key? key}) : super(key: key);

  @override
  _ExtraInfoPageState createState() => _ExtraInfoPageState();
}

class _ExtraInfoPageState extends State<ExtraInfoPage> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    if(done) return MainApp();
    return Scaffold(
      body: CustomExtraInfoForm(onFormCompleted: () {
        setState(() {
          done = true;
        });
      }),
    );
  }
}
class CustomExtraInfoForm extends StatefulWidget {
  final VoidCallback onFormCompleted;
  const CustomExtraInfoForm({Key? key, required this.onFormCompleted}) : super(key: key);


  @override
  _CustomExtraInfoFormState createState() => _CustomExtraInfoFormState();
}

class _CustomExtraInfoFormState extends State<CustomExtraInfoForm>
{
  Map<String, DismissibleImageCard> images = {};
  bool isUploading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _courseOfStudyController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _moreAboutYourselfController = TextEditingController();
  File? _selectedImage; // Variable to store the selected image file

  Future<void> _saveExtraInfo() async {
    if (_nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _courseOfStudyController.text.isEmpty ||
        _specialityController.text.isEmpty ||
        _moreAboutYourselfController.text.isEmpty) {
      _showErrorDialog("Invalid data!", "Please fill in all the required fields.");
      return;
    }

    var imageUrl = "";

    if (_selectedImage != null) {
      try {
        imageUrl = await _uploadImageToStorage(_selectedImage!);
      } catch (e) {
        _showErrorDialog("Image Upload Error", "Failed to upload image: $e");
        return;
      }
    }

    final userData = {
      "name": _nameController.text,
      "phone_number": _phoneNumberController.text,
      "course_of_study": _courseOfStudyController.text,
      "speciality": _specialityController.text,
      "more_about_yourself": _moreAboutYourselfController.text,
      "image_url": imageUrl,
      // Add more fields as needed
    };

    try {
      await _saveUserDataToFirestore(userData);
      _updateCurrentUserProfile(_nameController.text, imageUrl);
      widget.onFormCompleted();
    } catch (e) {
      _showErrorDialog("Save Data Error", "Failed to save user data: $e");
    }

  }



  Future<String> _uploadImageToStorage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child("user_photos");
    final imageRef = storageRef.child("${DateTime.now().millisecondsSinceEpoch}.png");
    await imageRef.putFile(imageFile, SettableMetadata(contentType: "image/jpeg"));
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveUserDataToFirestore(Map<String, dynamic> userData) async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Set the user's data in Firestore with the UID as the document ID
    await FirebaseFirestore.instance.collection("users").doc(uid).set(userData);
  }
  void _updateCurrentUserProfile(String displayName, String? photoUrl) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updateDisplayName(displayName);
      if (photoUrl != null) user.updatePhotoURL(photoUrl);
      user.reload();
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(image!.path);
      if (_selectedImage != null) {
        images.clear();
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        images[id] = DismissibleImageCard(
            image: _selectedImage!,
            onRemove: () {
              images.remove(id);
              setState(() {});
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.0),
            Center(
              child: Text(
                "Final details Chef",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30, // Adjust the font size as needed
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person_outline),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'UP Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.check_box_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _courseOfStudyController,
              decoration: InputDecoration(
                labelText: 'Course of Study',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.book_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _specialityController,
              decoration: InputDecoration(
                labelText: 'Speciality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.star_border_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _moreAboutYourselfController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'More About Yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.short_text_sharp),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Profile Picture:",
                  style: TextStyle(fontSize: 20),
                ),
                FilledButton(
                  onPressed: () {
                    _pickImage();
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

            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExtraInfo,
                child: Text(
                  'Finish',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0, // Adjust the font size here
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.0)), // Set minimum button size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _courseOfStudyController.dispose();
    _specialityController.dispose();
    _moreAboutYourselfController.dispose();
    super.dispose();
  }
}
