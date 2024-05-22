import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RateCard extends StatefulWidget {
  final String userID;
  final String userName;

  const RateCard({
    required this.userID,
    required this.userName,
    super.key,
  });

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  int currentRating = 0;
  bool isUploading = false;

  void updateRating(int rating) {
    setState(() {
      currentRating = rating;
    });
  }

  Future<void> submitRating() async {
    setState(() {
      isUploading = true;
    });

    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    final userDoc = await userRef.get();
    if (userDoc.data()!.containsKey('totalRating') &&
        userDoc.data()!.containsKey('ratingCount')) {
      final int totalRating = userDoc['totalRating'] + currentRating;
      final int ratingCount = userDoc['ratingCount'] + 1;
      await userRef.update({
        'totalRating': totalRating,
        'ratingCount': ratingCount,
      });
    } else {
      await userRef.set({
        'totalRating': currentRating,
        'ratingCount': 1,
      }, SetOptions(merge: true));
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rate ${widget.userName}"),
      content: Row(
        children: [
          IconButton(
            onPressed: () => updateRating(1),
            icon: Icon(
              currentRating >= 1 ? Icons.star : Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => updateRating(2),
            icon: Icon(
              currentRating >= 2 ? Icons.star : Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => updateRating(3),
            icon: Icon(
              currentRating >= 3 ? Icons.star : Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => updateRating(4),
            icon: Icon(
              currentRating >= 4 ? Icons.star : Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => updateRating(5),
            icon: Icon(
              currentRating >= 5 ? Icons.star : Icons.star_border,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: currentRating == 0
              ? null
              : isUploading
                  ? null
                  : () async {
                      await submitRating();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Rating submitted"),
                        ),
                      );
                    },
          child: isUploading
              ? const CircularProgressIndicator()
              : const Text("Rate"),
        ),
      ],
    );
  }
}
