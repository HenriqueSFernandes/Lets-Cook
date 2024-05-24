import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_cook/Components/NewProductPage/DismissibleImageCard.dart';
import 'package:lets_cook/main.dart';

var done = false;

class ExtraInfoPage extends StatefulWidget {
  const ExtraInfoPage({super.key});

  @override
  _ExtraInfoPageState createState() => _ExtraInfoPageState();
}

class _ExtraInfoPageState extends State<ExtraInfoPage> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    if (done) return const MainApp();
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

  const CustomExtraInfoForm({super.key, required this.onFormCompleted});

  @override
  _CustomExtraInfoFormState createState() => _CustomExtraInfoFormState();
}

class _CustomExtraInfoFormState extends State<CustomExtraInfoForm> {
  Map<String, DismissibleImageCard> images = {};
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _courseOfStudyController =
      TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _moreAboutYourselfController =
      TextEditingController();
  File? _selectedImage; // Variable to store the selected image file

  Future<void> _saveExtraInfo() async {
    setState(() {
      isUploading = true;
    });
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog(
          "Invalid data!", "Please fill in all the fields.");

      return;
    }
    if(_nameController.text.trim().length > 30){
      _showErrorDialog(
          "Invalid Name!", "Name cannot be more than 30 characters.");
      return;
    }
    if(_moreAboutYourselfController.text.trim().length > 200){
      _showErrorDialog(
          "Invalid Description!", "More about yourself cannot be more than 200 characters.");
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
      "name": _nameController.text.trim(),
      "phone_number": _phoneNumberController.text.trim(),
      "course_of_study": _courseOfStudyController.text.trim(),
      "speciality": _specialityController.text.trim(),
      "more_about_yourself": _moreAboutYourselfController.text.trim(),
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
    final imageRef =
        storageRef.child("${DateTime.now().millisecondsSinceEpoch}.png");
    await imageRef.putFile(
        imageFile, SettableMetadata(contentType: "image/jpeg"));
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
    setState(() {
      isUploading = false;
    });
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
              _selectedImage = null;
              setState(() {});
              _formKey.currentState!.validate(); // Validate the form after the image is selected
            });
      }
      _formKey.currentState!.validate(); // Validate the form after the image is selected
      _formKey.currentState!.validate(); // Validate the form after the image is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
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
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {_formKey.currentState!.validate();}); // Update the UI when the name changes
              },
              validator: (value) {
                if (value != null && value.trim().isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                counterText: _nameController.text.trim().length == 0 ? null : '${_nameController.text.trim().length}/30 characters',
                counterStyle: TextStyle(
                  color: _nameController.text.trim().length > 30 ? Colors.red : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _phoneNumberController,
              onChanged: (value) {
                setState(() {_formKey.currentState!.validate();}); // Update the UI when the name changes
              },
              validator: (value) {
                if (value != null && value.trim().isEmpty) {
                  return 'UP number cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'UP Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.check_box_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _courseOfStudyController,
              onChanged: (value) {
                setState(() {_formKey.currentState!.validate();}); // Update the UI when the name changes
              },
              validator: (value) {
                if (value != null && value.trim().isEmpty) {
                  return 'Course cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Course of Study',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.book_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _specialityController,
              onChanged: (value) {
                setState(() {_formKey.currentState!.validate();}); // Update the UI when the name changes
              },
              validator: (value) {
                if (value != null && value.trim().isEmpty) {
                  return 'Specialty cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Speciality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.star_border_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _moreAboutYourselfController,
              onChanged: (value) {
                setState(() {_formKey.currentState!.validate();}); // Update the UI when the name changes
              },
              validator: (value) {
                if (value != null && value.trim().isEmpty) {
                  return 'Description cannot be empty';
                }
                return null;
              },
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'More About Yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.short_text_sharp),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                counterText: _moreAboutYourselfController.text.trim().length == 0 ? null : '${_moreAboutYourselfController.text.trim().length}/200 characters',
                counterStyle: TextStyle(
                  color: _moreAboutYourselfController.text.trim().length > 200 ? Colors.red : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            FormField(
              validator: (value) {
                if (_selectedImage == null) {
                  return 'Please select a profile picture.';
                }
                return null;
              },
              builder: (FormFieldState state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            state.didChange(_selectedImage); // Notify the FormField that the value has changed
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
                    if (state.hasError)
                      Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                  ],
                );
              },
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
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExtraInfo,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all(const Size(
                      double.infinity, 50.0)), // Set minimum button size
                ),
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0, // Adjust the font size here
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    await FirebaseAuth.instance.currentUser!.delete();
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/sign-in", (route) => false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  minimumSize: MaterialStateProperty.all(const Size(
                      double.infinity, 50.0)), // Set minimum button size
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0, // Adjust the font size here
                  ),
                ),
              ),
            ),
          ],
        ),
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
