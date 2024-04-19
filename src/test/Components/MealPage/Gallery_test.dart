import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photo_view/photo_view.dart';
import 'package:lets_cook/Components/MealPage/Gallery.dart'; // Import your Gallery.dart file

void main() {
  testWidgets('Gallery widget test', (WidgetTester tester) async {
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
            images: mockImages,
          ),
        ),
      );

      // Verify that the initial image is displayed using PhotoView widget
      expect(find.byType(PhotoView), findsOneWidget);

      // Verify that the text showing the current image index is displayed
      expect(find.text('1/${mockImages.length}'), findsOneWidget);

      // Tap on the next button
      await tester.tap(find.byType(ElevatedButton).at(1)); // Use the index to specify the button
      await tester.pumpAndSettle();

      // Verify that the next image is displayed
      expect(find.text('2/${mockImages.length}'), findsOneWidget);

      // Tap on the previous button
      await tester.tap(find.byType(ElevatedButton).at(0)); // Use the index to specify the button
      await tester.pumpAndSettle();

      // Verify that the previous image is displayed again
      expect(find.text('1/${mockImages.length}'), findsOneWidget);
    });
  });
}