/*

PROFILE STATES

*/

import 'package:social_bloc/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

// INITIAL STATE
class ProfileInitial extends ProfileState {}

// LOADING STATE
class ProfileLoading extends ProfileState {}

// LOADED STATE
class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

// ERROR STATE
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
