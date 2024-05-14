import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';

class UserButton extends StatelessWidget {
  final String userName;
  final String userID;
  final String mealID;

  const UserButton({
    required this.userName,
    required this.userID,
    required this.mealID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            userID: userID,
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
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("lib/resources/default_userimage.png"),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            userName,
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
