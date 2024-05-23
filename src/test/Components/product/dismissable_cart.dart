import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_cook/Components/NewProductPage/DismissibleImageCard.dart';

void main() {
  group('DismissibleImageCard tests', () {
    testWidgets('Widget renders correctly with given image file', (WidgetTester tester) async {
      final File testImage = File('path_to_test_image.jpg'); // Provide a path to a test image
      await tester.pumpWidget(MaterialApp(
        home: DismissibleImageCard(image: testImage, onRemove: () {}),
      ));
      expect(find.byType(DismissibleImageCard), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Tapping remove button triggers onRemove callback', (WidgetTester tester) async {
      bool removed = false;
      final File testImage = File('path_to_test_image.jpg');
      await tester.pumpWidget(MaterialApp(
        home: DismissibleImageCard(
          image: testImage,
          onRemove: () {
            removed = true;
          },
        ),
      ));
      await tester.tap(find.byIcon(Icons.cancel_outlined));
      expect(removed, true);
    });

    testWidgets('Image file is displayed correctly within the card', (WidgetTester tester) async {
      final File testImage = File('path_to_test_image.jpg');
      await tester.pumpWidget(MaterialApp(
        home: DismissibleImageCard(image: testImage, onRemove: () {}),
      ));
      expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is FileImage), findsOneWidget);
    });

    testWidgets('Card has correct dimensions and border radius', (WidgetTester tester) async {
      final File testImage = File('path_to_test_image.jpg');
      await tester.pumpWidget(MaterialApp(
        home: DismissibleImageCard(image: testImage, onRemove: () {}),
      ));
      final Container container = tester.widget(find.byType(Container));
      expect(container.constraints!.maxWidth, 100);
      expect(container.constraints!.maxHeight, 100);
      expect(container.decoration, BoxDecoration(borderRadius: BorderRadius.circular(20)));
    });

    testWidgets('FileImage widget is used to display the image', (WidgetTester tester) async {
      final File testImage = File('path_to_test_image.jpg');
      await tester.pumpWidget(MaterialApp(
        home: DismissibleImageCard(image: testImage, onRemove: () {}),
      ));
      final Image imageWidget = tester.widget(find.byType(Image));
      expect(imageWidget.image, isA<FileImage>());
    });
  });
}
