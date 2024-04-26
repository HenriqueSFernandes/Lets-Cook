import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/main.dart';
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _courseOfStudyController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _moreAboutYourselfController = TextEditingController();
  File? _selectedImage; // Variable to store the selected image file

  Future<void> _saveExtraInfo() async {
    // Add your logic to save extra information here
    // For example, you can send the data to a backend server
    // or store it locally on the device
    // Also, include logic to handle the selected image

    // Check if all required fields are filled
    if (_nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _courseOfStudyController.text.isEmpty ||
        _specialityController.text.isEmpty ||
        _moreAboutYourselfController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid data!"),
            content: const Text("Please fill in all the required fields."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Perform image upload if an image is selected
    if (_selectedImage != null) {
      // Example code for uploading the selected image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child("user_photos");
      final imageRef = storageRef.child("${DateTime.now().millisecondsSinceEpoch}.png");
      try {
        await imageRef.putFile(
          _selectedImage!,
          SettableMetadata(contentType: "image/jpeg"),
        );
        final imageUrl = await imageRef.getDownloadURL();
        // Now you have the imageUrl which can be stored along with other user data
        print("Uploaded image URL: $imageUrl");
      } catch (e) {
        print("Error uploading image: $e");
        // Handle upload error
      }
    }

    // If you reach here, all data is valid and image (if any) is uploaded
    // Proceed to save user data to Firestore or any other backend
    // Example code for saving user data to Firestore
    final userData = {
      "name": _nameController.text,
      "phone_number": _phoneNumberController.text,
      "course_of_study": _courseOfStudyController.text,
      "speciality": _specialityController.text,
      "more_about_yourself": _moreAboutYourselfController.text,
      // Add more fields as needed
    };

    try {
      await FirebaseFirestore.instance.collection("users").add(userData);
      // Data saved successfully
      print("User data saved successfully!");
      widget.onFormCompleted();
    } catch (e) {
      print("Error saving user data: $e");
      // Handle error
    }
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = pickedImage != null ? File(pickedImage.path) : null;
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
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'UP Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _courseOfStudyController,
              decoration: InputDecoration(
                labelText: 'Course of Study',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _specialityController,
              decoration: InputDecoration(
                labelText: 'Speciality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _moreAboutYourselfController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'More About Yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload  Photo'),
            ),
            SizedBox(height: 20.0),
            Container(

              child: ElevatedButton(
                onPressed: _saveExtraInfo,
                child: Text('Save Info'),
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
