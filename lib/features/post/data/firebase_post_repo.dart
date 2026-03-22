import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_bloc/features/post/domain/entities/comment.dart';
import 'package:social_bloc/features/post/domain/entities/post.dart';
import 'package:social_bloc/features/post/domain/repo/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // STORE THE POST IN A COLLECTION CALLED "posts"
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection("posts");

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // GET ALL POST WITH THE MOST RECENT POST AT THE TOP
      final postsSnapshot = await postsCollection
          .orderBy('timestamp', descending: true)
          .get();

      // CONVERT EACH FIRESTORE DOCUMENT TO JSON --> LIST OF POSTS
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // FETCH POST SNAPSHOT WITH THIS UID
      final postsSnapshot = await postsCollection
          .where('userId', isEqualTo: userId)
          .get();

      // CONVERT FIRESTORE DOCUMENT FROM JSON --> LIST OF POST
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching user posts: $e");
    }
  }

  @override
  Future<void> toogleLikePost(String postId, String userId) async {
    try {
      // Get the post documents from firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Check if the user has already liked the post
        final hasLiked = post.likes.contains(userId);

        // Update the likes list
        if (hasLiked) {
          post.likes.remove(userId); // Unlike
        } else {
          post.likes.add(userId); //Like
        }

        // update the post document with the new like list
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error toggling likes: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // Convert json object to post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Add new comment
        post.comments.add(comment);

        // Update the post documnet in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // Convert json object to post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Add new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // Update the post documnet in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error deleting comment: $e");
    }
  }
}
