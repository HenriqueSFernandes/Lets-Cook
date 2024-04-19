import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:lets_cook/Components/MealPage/ImageCard.dart'; // Import your ImageCard.dart file

void main() {
  testWidgets('ImageCard Widget Test', (WidgetTester tester) async {
    // Mock the network image
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageCard(
              image: NetworkImage('http://example.com/my_image.png'),
            ),
          ),
        ),
      );

      // Verify that the widget renders correctly
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
