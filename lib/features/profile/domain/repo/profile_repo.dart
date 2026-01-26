// PROFILE REPOSITORY

import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  // FETCH USER PROFILE
  Future<ProfileUser?> fetchUserProfile(String uid);

  // UPDATE USER PROFILE
  Future<void> updateProfile(ProfileUser updatedProfile);
}
