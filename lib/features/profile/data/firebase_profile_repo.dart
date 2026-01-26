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
          return ProfileUser(
            uid: uid,
            email: userData["email"],
            name: userData["name"],
            bio: userData["bio"] ?? '',
            profileImageUrl: userData["profileImageUrl"].toString(),
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
}
