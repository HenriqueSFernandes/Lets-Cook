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
              foregroundImage:
                  AssetImage("lib/resources/default_userimage.png"),
              backgroundColor: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              userName,
              overflow: TextOverflow.ellipsis,
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
