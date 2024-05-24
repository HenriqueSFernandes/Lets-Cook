import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photo_view/photo_view.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart'; // Ensure this path is correct for your project

void main() {
  testWidgets('Gallery initial image and state', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Define some mock network images
      List<NetworkImage> mockImages = [
        NetworkImage('https://example.com/image1.jpg'),
        NetworkImage('https://example.com/image2.jpg'),
        NetworkImage('https://example.com/image3.jpg'),
      ];

      // Build the Gallery widget
      await tester.pumpWidget(
        MaterialApp(
          home: Gallery(
            initialIndex: 0,
            imageURLs: mockImages.map((image) => image.url).toList(),
          ),
        ),
      );

      // Verify that the initial image is displayed using PhotoView widget
      expect(find.byType(PhotoView), findsOneWidget);

      // Verify that the text showing the current image index is displayed
      expect(find.text('1/${mockImages.length}'), findsOneWidget);
    });
  });

}
