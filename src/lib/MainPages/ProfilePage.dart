import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      actions: [
        SignedOutAction(
              (context) async {
            try {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/sign-in"); // Ensure "/sign-in" is the correct route name for the sign-in page
            } catch (e) {
              print('Sign-out error: $e');
            }
          },
        ),
      ],
    );
  }
}
