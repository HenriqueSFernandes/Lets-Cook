import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:lets_cook/MainPages/LoginPage.dart';

void main() {
  testWidgets('LoginPage widget test', (WidgetTester tester) async {
    // Create a MockUser
    final mockUser = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    // Create a MockFirebaseAuth instance
    final mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);

    // Build the LoginPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(auth: mockFirebaseAuth),
      ),
    );

    // Verify that the LoginPage widget is built correctly
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify that the MainApp widget is displayed when there is a user
    expect(find.byType(MainApp), findsOneWidget);
  });

  testWidgets('LoginPage widget test without user', (WidgetTester tester) async {
    // Create a MockFirebaseAuth instance without a user
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Build the LoginPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(auth: mockFirebaseAuth),
      ),
    );

    // Verify that the LoginPage widget is built correctly
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify that the SignInScreen widget is displayed when there is no user
    expect(find.byType(SignInScreen), findsOneWidget);
  });
}