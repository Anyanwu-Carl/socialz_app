import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/post/domain/entities/comment.dart';
import 'package:social_bloc/features/post/domain/entities/post.dart';
import 'package:social_bloc/features/post/domain/repo/post_repo.dart';
import 'package:social_bloc/features/post/presentation/cubits/posts_states.dart';
import 'package:social_bloc/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
    : super(PostsInitial());

  // CREATE A NEW POST
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      // HANDLE IMAGE UPLOAD FOR MOBILE PLATFORMS (USING FILE PATH)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      // HANDLE IMAGE UPLOAD FOR WEB PLATFORMS (USING FILE BYTES)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // GIVE IMAGE URL TO POST
      final newPost = post.copyWith(imageUrl: imageUrl);

      // CREATE POST IN FIREBASE(BACKEND)
      postRepo.createPost(newPost);

      // RE-FETCH ALL POSTS
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // FETCH ALL POSTS
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // DELETE A POST
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }

  // Toogle like on a post
  Future<void> toogleLikePost(String postId, String userId) async {
    try {
      await postRepo.toogleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toogle like: $e"));
    }
  }

  // Add comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // Delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
