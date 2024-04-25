import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomLoginForm();
        }
        return const MainApp();
      },
    );
  }
}

class CustomLoginForm extends StatelessWidget {
  const CustomLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Center(
                child: Text(
                  'Are you cooking or eating today, chef?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30, // Adjust the font size as needed
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0), // Increased height
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email or Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Increased borderRadius
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Increased height
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Increased borderRadius
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0), // Increased height
              Container(
                width: double.infinity, // Make the button take up all available space
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your authentication logic here
                  },
                  child: Text('Sign In'),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Implement your forgot password logic here
                },
                child: Text('Forgot Password?'),
              ),
              Container(
                width: double.infinity, // Make the button take up all available space
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement your Google sign-in logic here
                  },
                  icon: Container(
                    height: 24.0, // Set the height as needed
                    width: 24.0, // Set the width as needed
                    child: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  label: Text('Sign In with Google'),
                ),
              ),
              SizedBox(height: 200.0), // Increased height
              Container(
                width: double.infinity, // Make the button take up all available space
                child: Text(
                  'Don\'t have an account?',
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(
                    fontSize: 20, // Adjust the font size as needed
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity, // Make the button take up all available space
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your sign-up logic here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                    padding: EdgeInsets.all(16.0), // Increased padding
                  ),
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
}
