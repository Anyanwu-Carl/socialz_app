import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';
import 'package:social_bloc/features/profile/domain/repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // GET USER DOCUMENT FROM FIRESTORE
      final userDoc = await firebaseFirestore
          .collection("users")
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          // Fetch followers and following
          final followers = List<String>.from(userData["followers"] ?? []);
          final following = List<String>.from(userData["following"] ?? []);

          return ProfileUser(
            uid: uid,
            email: userData["email"],
            name: userData["name"],
            bio: userData["bio"] ?? '',
            profileImageUrl: userData["profileImageUrl"].toString(),
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    }
    // CATCH ERRORS
    catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      // CONVERT UPDATED PROFILE TO JSON TO STORE IN FIRESTORE
      await firebaseFirestore
          .collection("users")
          .doc(updatedProfile.uid)
          .update({
            'bio': updatedProfile.bio,
            'profileImageUrl': updatedProfile.profileImageUrl,
          });
    }
    // CATCH ERRORS
    catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> togglefollow(String currentUid, String targetUid) async {
    final currentUserDoc = await firebaseFirestore
        .collection("users")
        .doc(currentUid)
        .get();
    final targetUserDoc = await firebaseFirestore
        .collection("users")
        .doc(currentUid)
        .get();

    if (currentUserDoc.exists && targetUserDoc.exists) {
      final currentUserData = currentUserDoc.data();
      final targetUserData = targetUserDoc.data();

      if (currentUserData != null && targetUserData != null) {
        final List<String> currentFollowing = List<String>.from(
          currentUserData["following"] ?? [],
        );

        // Check if the current user is already following the target user
        if (currentFollowing.contains(targetUid)) {
          // Unfollow
          await firebaseFirestore.collection("users").doc(currentUid).update({
            "following": FieldValue.arrayRemove([targetUid]),
          });

          await firebaseFirestore.collection("users").doc(targetUid).update({
            "followers": FieldValue.arrayRemove([currentUid]),
          });
        } else {
          // follow
          await firebaseFirestore.collection("users").doc(currentUid).update({
            "following": FieldValue.arrayUnion([targetUid]),
          });

          await firebaseFirestore.collection("users").doc(targetUid).update({
            "followers": FieldValue.arrayUnion([currentUid]),
          });
        }
      }
    }
  }
}
