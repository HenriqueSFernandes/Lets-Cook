import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ExtraInfoPage.dart';
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomSignUpForm(),
    );
  }
}

class CustomSignUpForm extends StatefulWidget {
  const CustomSignUpForm({Key? key}) : super(key: key);

  @override
  _CustomSignUpFormState createState() => _CustomSignUpFormState();
}

class _CustomSignUpFormState extends State
{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      if (_passwordController.text == _repeatPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ExtraInfoPage(), // Replace SignUpPage() with the appropriate class name of SignUp.dart
          ),
        );

      } else {
        // Passwords don't match, handle error
        print('Passwords do not match');
      }
    } catch (e) {
      // Handle sign-up errors
      print('Sign-up error: $e');
    }
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
                "Welcome Chef\nLet's cook",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30, // Adjust the font size as needed
                ),
                textAlign: TextAlign.center,
              ),

            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                child: Text('Sign Up'),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to login page

              },
              child: Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
