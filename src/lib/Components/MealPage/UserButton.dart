import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';

class UserButton extends StatefulWidget {
  final String userName;
  final String userID;
  final String mealID;
  String imageUrl = "";

  UserButton({
    required this.userName,
    required this.userID,
    required this.mealID,
    super.key,
  });

  @override
  State<UserButton> createState() => _UserButtonState();
}

class _UserButtonState extends State<UserButton> {
  void getImageUrl() async {
    String url = "";
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(widget.userID);
    await userRef.get().then(
      (value) {
        url = value['image_url'];
      },
    );
    setState(() {
      widget.imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    getImageUrl();
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            userID: widget.userID,
          ),
        ),
      ),
      child: Row(

        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.imageUrl == ""
                    ? AssetImage("lib/resources/default_userimage.png") as ImageProvider
                    : NetworkImage(widget.imageUrl) as ImageProvider,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
