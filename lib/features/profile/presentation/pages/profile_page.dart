import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/domain/entity/app_user.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/features/post/components/post_tile.dart';
import 'package:social_bloc/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_bloc/features/post/presentation/cubits/posts_states.dart';
import 'package:social_bloc/features/profile/presentation/component/bio_box.dart';
import 'package:social_bloc/features/profile/presentation/component/follow_button.dart';
import 'package:social_bloc/features/profile/presentation/component/profile_stats.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_bloc/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_bloc/features/profile/presentation/pages/follower_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // CUBITS
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // CURRENT USER
  late AppUser? currentUser = authCubit.currentUser;

  // Post
  int postCount = 0;

  // ON START-UP
  @override
  void initState() {
    super.initState();

    // LOAD USER PROFILE DATA
    profileCubit.fetchUserProfile(widget.uid);
  }

  // ----------Follow and Unfollow-----------------
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return; // Return is profile is not loaded
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // Optimistically update the UI
    setState(() {
      // Unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }
      // Follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // Perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // Revert update if there was an error
      setState(() {
        // Unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        }
        // Follow
        else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // Is own post
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // LOADED
        if (state is ProfileLoaded) {
          // GET LOADED USER
          final user = state.profileUser;

          // Scaffold
          return Scaffold(
            // Appbar
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // Edit profile button (only fow own profile)
                if (isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
              ],
            ),
            // Body
            body: ListView(
              children: [
                // USER EMAIl
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PROFILE PIC
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // LOADING...
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),

                  // ERROR (FAILED TO LOAD IMAGE) --> DISPLAY DEFAULT AVATAR
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  // LOADED IMAGE
                  imageBuilder: (context, imageProvider) => Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Profile stats
                ProfileStats(
                  postCount: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowerPage(
                        followers: user.followers,
                        following: user.following,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Follow button
                if (!isOwnPost)
                  FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: user.followers.contains(currentUser!.uid),
                  ),

                const SizedBox(height: 25),

                // BIO
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BioBox(text: user.bio),

                // POST
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        "Post",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // List of posts
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    // Post loaded
                    if (state is PostsLoaded) {
                      // Filter posts by userID
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      postCount = userPosts.length;

                      return ListView.builder(
                        itemCount: postCount,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // Get individual post
                          final post = userPosts[index];

                          // Return as post tile UI
                          return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    }
                    // Post loading
                    else if (state is PostsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Error
                    else {
                      return const Center(child: Text("No Posts..."));
                    }
                  },
                ),
              ],
            ),
          );
        }
        // LOADING
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Center(
            child: Text(
              "No profile found",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          );
        }
      },
    );
  }
}
