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
              Navigator.pushReplacementNamed(context, "sign-in");
            } catch (e) {
              print('Sign-out error: $e');
            }
          },
        )
      ],
    );
  }
}
