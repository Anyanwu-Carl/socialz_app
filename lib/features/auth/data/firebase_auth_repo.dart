import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_bloc/features/auth/domain/entity/app_user.dart';
import 'package:social_bloc/features/auth/domain/repo/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // ATTEMPT TO SIGN IN WITH EMAIL & PASSWORD
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // FETCH USER DOCUMENT FROM FIRESTORE
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      // CREATE USER
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc["name"],
      );

      // RETURN APP USER
      return user;
    }
    // CATCH ANY ERRORS
    catch (e) {
      throw Exception("Login Failed: $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // ATTEMPT TO SIGN UP WITH EMAIL & PASSWORD
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // CREATE USER
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // SAVE USER DATA TO FIRESTORE
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      // RETURN APP USER
      return user;
    }
    // CATCH ANY ERRORS
    catch (e) {
      throw Exception("Sign Up Failed: $e");
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // GET CURRENT LOGGED IN USER FROM FIREBASE
    final firebaseUser = firebaseAuth.currentUser;

    // IF NO USER IS LOGGED IN
    if (firebaseUser == null) {
      return null;
    }

    // FETCH USER DOCUMENT FROM FIRESTORE
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    // CHECK IF USER DOC EXIST
    if (!userDoc.exists) {
      return null;
    }

    // USER IS LOGGED IN
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc["name"],
    );
  }
}
