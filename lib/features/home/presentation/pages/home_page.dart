import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/home/presentation/components/my_drawer.dart';
import 'package:social_bloc/features/post/components/post_tile.dart';
import 'package:social_bloc/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_bloc/features/post/presentation/cubits/posts_states.dart';
import 'package:social_bloc/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // POST CUBIT
  late final postCubit = context.read<PostCubit>();

  //ON START UP
  @override
  void initState() {
    super.initState();

    // FETCH ALL POSTS
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String, postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // LOADING
          if (state is PostsLoading && state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }
          // LOADED
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No Posts"));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // GET INDIVIDUAL POST
                final post = allPosts[index];

                // IMAGE
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(String, post.id),
                );
              },
            );
          }
          // ERROR
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
