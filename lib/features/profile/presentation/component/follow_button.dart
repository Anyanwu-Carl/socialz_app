/* 

FOLLOW BUTTON
 This is a follow and unfollow button
 -------------------------------------

 --> Create a function(toggleFollow())
 --> isFollowing (e.g false --> Then we'll show the follow button instead of unfollow button)

*/

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          padding: const EdgeInsets.all(25.0),
          onPressed: onPressed,
          color: isFollowing
              ? Theme.of(context).colorScheme.primary
              : Colors.blue,
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
