// AUTH STATES

import 'package:social_bloc/features/auth/domain/entity/app_user.dart';

abstract class AuthState {}

// INITIAL STATE
class AuthInitial extends AuthState {}

// LOADING STATE
class AuthLoading extends AuthState {}

// AUTHENTICATED STATE
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

// UNAUTHENTICATED STATE
class Unauthenticated extends AuthState {}

// ERROR STATE
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
