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

class CustomLoginForm extends StatefulWidget {
  const CustomLoginForm({Key? key}) : super(key: key);

  @override
  _CustomLoginFormState createState() => _CustomLoginFormState();
}

class _CustomLoginFormState extends State<CustomLoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email or Username',
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
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  child: Text('Sign In'),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement your Google sign-in logic here
                  },
                  icon: Container(
                    height: 24.0,
                    width: 24.0,
                    child: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  label: Text('Sign In with Google'),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Implement your forgot password logic here
                },
                child: Text('Forgot Password?'),
              ),
              SizedBox(height: 200.0),
              Container(
                width: double.infinity,
                child: Text(
                  'Don\'t have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your sign-up logic here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text('Sign Up'),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
