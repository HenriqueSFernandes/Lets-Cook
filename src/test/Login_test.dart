import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_cook/main.dart';
import 'package:lets_cook/MainPages/LoginPage.dart';
import 'package:lets_cook/MainPages/ExtraInfoPage.dart';
import 'package:lets_cook/MainPages/SignUp.dart';
void main() {
  testWidgets('LoginPage widget test', (WidgetTester tester) async {
    // Build our LoginPage widget
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Verify if the login form is displayed initially
    expect(find.byType(CustomLoginForm), findsOneWidget);

    // Simulate a scenario where user logs in successfully
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    );

    // Rebuild the widget after signing in
    await tester.pump();

    // Verify if the MainApp widget is displayed after successful login
    expect(find.byType(MainApp), findsOneWidget);

    // Simulate a scenario where user is not found in Firestore
    FirebaseFirestore.instance.collection('users').doc('nonexistentUserID').delete();

    // Rebuild the widget after checking user data
    await tester.pump();

    // Verify if the ExtraInfoPage widget is displayed when user is not found in Firestore
    expect(find.byType(ExtraInfoPage), findsOneWidget);

    // Tap on the "Sign Up" button and verify if it navigates to the SignUpPage
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpPage), findsOneWidget);
  });
}
