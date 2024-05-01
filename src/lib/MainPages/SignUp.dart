import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ExtraInfoPage.dart';
import 'LoginPage.dart';
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
            builder: (context) => ExtraInfoPage(),
          ),
        );
      } else {
        // Passwords don't match
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Passwords do not match.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle sign-up errors
      print('Sign-up error: $e');
      // Show error message
      String errorMessage = 'An error occurred. Please try again later.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
         case 'weak-password':
              errorMessage = 'Password is too weak. Please choose a stronger password.';
              break;
          case 'email-already-in-use':
            errorMessage = 'Email is already in use. Please use a different email.';
            break;
        // Add more cases to handle specific error codes if needed
          default:
            errorMessage = 'Sign-up failed. Please try again later.';
            break;
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.email_outlined),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),

            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.password_sharp),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.password_sharp ),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                child: Text('Sign Up',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0, // Adjust the font size here
                ),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.0)), // Set minimum button size
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Replace LoginPage() with the appropriate class name of Login.dart
                  ),
                );
              },
              child: Text(
                'Already have an account? ',
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Replace LoginPage() with the appropriate class name of Login.dart
                  ),
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
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
