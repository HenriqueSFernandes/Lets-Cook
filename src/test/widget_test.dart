import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/main.dart' as app;

void main() {
  testWidgets('App should load without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MainApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should have an app bar with the title "Let\'s Cook"', (WidgetTester tester) async {
  await tester.pumpWidget(const app.MainApp());
  expect(find.text("Let's Cook"), findsOneWidget);
  });

testWidgets('App should have a bottom navigation bar with home, search, and settings icons', (WidgetTester tester) async {
await tester.pumpWidget(const app.MainApp());
expect(find.byIcon(Icons.home), findsOneWidget);
expect(find.byIcon(Icons.add), findsOneWidget);
expect(find.byIcon(Icons.person), findsOneWidget);
});

testWidgets('Navigation to home page should work', (WidgetTester tester) async {
await tester.pumpWidget(const app.MainApp());
await tester.tap(find.byIcon(Icons.home));
await tester.pumpAndSettle();
expect(find.byKey(const PageStorageKey('HomePage')), findsOneWidget);
});

testWidgets('Navigation to search page should work', (WidgetTester tester) async {
await tester.pumpWidget(const app.MainApp());
await tester.tap(find.byIcon(Icons.search));
await tester.pumpAndSettle();
expect(find.byKey(const PageStorageKey('SearchPage')), findsOneWidget);
});

testWidgets('Navigation to settings page should work', (WidgetTester tester) async {
await tester.pumpWidget(const app.MainApp());
await tester.tap(find.byIcon(Icons.settings));
await tester.pumpAndSettle();
expect(find.byKey(const PageStorageKey('SettingsPage')), findsOneWidget);
});
}