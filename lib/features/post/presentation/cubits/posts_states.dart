/* 

POST STATES

*/

import 'package:social_bloc/features/post/domain/entities/post.dart';

abstract class PostState {}

// INITIAL STATE
class PostsInitial extends PostState {}

// LOADING STATE
class PostsLoading extends PostState {}

// UPLOADING STATE
class PostUploading extends PostState {}

// ERROR STATE
class PostsError extends PostState {
  final String message;
  PostsError(this.message);
}

// LOADED STATE
class PostsLoaded extends PostState {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
