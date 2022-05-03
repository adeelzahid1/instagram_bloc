import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? FlatButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : FlatButton(
            onPressed: () {},
            color:
                isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
            textColor: isFollowing ? Colors.black : Colors.white,
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }
}