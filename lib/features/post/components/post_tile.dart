import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/domain/entity/app_user.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/features/post/domain/entities/post.dart';
import 'package:social_bloc/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_cubits.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // CUBITS
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // CURRENT USER
  AppUser? currentUser;

  // PROFILE USER
  ProfileUser? postUser;

  // ON START UP
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // LIKES
  // User tapped like button
  void toogleLikePost() {
    // Current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // Optimistically like and update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // Unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // Like
      }
    });

    // update like status
    postCubit.toogleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      // If there's an error, revert back to it's original values
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert Like
        }
      });
    });
  }

  // SHOW OPTIONS FOR POST DELETION
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // DELETE BUTTON
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // PROFILE PIC
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),

                const SizedBox(width: 10),
                // USERNAME
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // DELETE BUTTON
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          // IMAGE
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // BUTTONS --> Like, comment, and timestamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // LIKE BUTTON
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toogleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      // Like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Comment Button
                const Icon(Icons.comment),
                const Text("0"),

                const Spacer(),

                // Time stamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
