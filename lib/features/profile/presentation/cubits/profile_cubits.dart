import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';
import 'package:social_bloc/features/profile/domain/repo/profile_repo.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_bloc/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitial());

  // FETCH USER PROFILE USING REPO -> USEFUL FOR LOADING SINGLE PROFILE PAGES
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Return user profile -> useful for loading many profiles for post
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // UPDATE BIO AND PROFILE PICTURE
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {
      // FETCH CURRENT PROFILE FIRST
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      // PROFILE PICTURE UPDATE
      String? imageDownloadUrl;

      // ENSURE THERE'S AN IMAGE TO UPLOAD
      if (imageWebBytes != null || imageMobilePath != null) {
        // FOR MOBILE PLATFORM
        if (imageMobilePath != null) {
          // UPLOAD IMAGE AND GET DOWNLOAD URL
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        }
        // FOR WEB PLATFORM
        else if (imageWebBytes != null) {
          // UPLOAD IMAGE AND GET DOWNLOAD URL
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
            imageWebBytes,
            uid,
          );
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload profile picture"));
          return;
        }
      }

      // UPDATE NEW PROFILE
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // UPDATE IN REPO
      await profileRepo.updateProfile(updatedProfile);

      // RE-FETCH THE UPDATED PROFILE
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
