import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExtraInfoPage extends StatelessWidget {
  const ExtraInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomExtraInfoForm(),
    );
  }
}

class CustomExtraInfoForm extends StatefulWidget {
  const CustomExtraInfoForm({Key? key}) : super(key: key);

  @override
  _CustomExtraInfoFormState createState() => _CustomExtraInfoFormState();
}

class _CustomExtraInfoFormState extends State
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
    if (_selectedImage != null) {
      // Upload the selected image to the server
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
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
