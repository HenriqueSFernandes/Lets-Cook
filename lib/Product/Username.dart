import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String userName;

  const UserWidget(this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 7, bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.background,
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              // foregroundImage: NetworkImage(
              //     "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png"),
              foregroundImage:
                  AssetImage("lib/resources/default_userimage.png"),
              backgroundColor: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              userName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
