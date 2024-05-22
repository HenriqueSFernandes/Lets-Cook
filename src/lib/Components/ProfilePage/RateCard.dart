import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int initialRating = 0;
  int currentRating = 0;
  bool alreadyRated = false;
  bool isUploading = false;

  Future<bool> userAlreadyRated() async {
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    final userDoc = await userRef.get();
    if (userDoc.data()!.containsKey('ratings')) {
      final List<dynamic> ratings = userDoc['ratings'];
      for (var rating in ratings) {
        if (rating['userID'] == FirebaseAuth.instance.currentUser!.uid) {
          currentRating = rating['rating'];
          initialRating = rating['rating'];
          return true;
        }
      }
    }
    return false;
  }

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
        userDoc.data()!.containsKey('ratingCount') &&
        userDoc.data()!.containsKey('ratings')) {
      List<dynamic> ratings = List.from(userDoc['ratings']);
      if (!alreadyRated) {
        // If user has been rated before, but not by the current user.
        final int totalRating = userDoc['totalRating'] + currentRating;
        final int ratingCount = userDoc['ratingCount'] + 1;
        ratings.add({
          'userID': FirebaseAuth.instance.currentUser!.uid,
          'rating': currentRating,
        });
        await userRef.update({
          'totalRating': totalRating,
          'ratingCount': ratingCount,
          'ratings': ratings,
        });
      } else {
        // If the user has been rated by the current user before.
        ratings.removeWhere((rating) =>
            rating['userID'] == FirebaseAuth.instance.currentUser!.uid);
        final int totalRating =
            userDoc['totalRating'] - initialRating + currentRating;
        ratings.add({
          'userID': FirebaseAuth.instance.currentUser!.uid,
          'rating': currentRating,
        });
        await userRef.update({
          'totalRating': totalRating,
          'ratings': ratings,
        });
      }
    } else {
      // If the user has not been rated before.
      await userRef.set({
        'totalRating': currentRating,
        'ratingCount': 1,
        'ratings': [
          {
            'userID': FirebaseAuth.instance.currentUser!.uid,
            'rating': currentRating,
          },
        ],
      }, SetOptions(merge: true));
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    userAlreadyRated().then((value) => setState(() {
          alreadyRated = value;
        }));
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
          onPressed: currentRating == 0 || currentRating == initialRating
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
