import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/data/firebase_auth_repo.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_states.dart';
import 'package:social_bloc/features/auth/presentation/pages/auth_page.dart';
import 'package:social_bloc/features/home/presentation/pages/home_page.dart';
import 'package:social_bloc/features/post/data/firebase_post_repo.dart';
import 'package:social_bloc/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_bloc/features/profile/data/firebase_profile_repo.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_bloc/features/storage/data/firebase_storage_repo.dart';
import 'package:social_bloc/features/storage/domain/storage_repo.dart';
import 'package:social_bloc/themes/light_mode.dart';

/*

APP - ROOT LEVEL

------------------------------------------------------

REPOSITORIES: FOR THE DATABASE
  - FIREBASE

BLOC PROVIDERS: FOR STATE MANAGEMENT
  - AUTH
  - PROFILE
  - POST
  - SEARCH
  - THEME

CHECK AUTH STATE
  - UNAUTHENTICATED --> AUTH PAGE (LOGIN/ REGISTER)
  - AUTHENTICATED --> HOME PAGE

 */

class MyApp extends StatelessWidget {
  // AUTH REPO
  final firebaseAuthRepo = FirebaseAuthRepo();

  // PROFILE REPO
  final firebaseProfileRepo = FirebaseProfileRepo();

  // STORAGE REPO
  final firebaseStorageRepo = FirebaseStorageRepo();

  // POST REPO
  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PROVIDE CUBIT TO APP
    return MultiBlocProvider(
      providers: [
        // AUTH CUBIT
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // PROFILE CUBIT
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // POST CUBIT
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
      ],
      child: MaterialApp(
        title: "Social Media App",
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            // UNAUTHENTICATED --> AUTH PAGE (LOGIN/REGISTER)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // AUTHENTICATED --> HOMEPAGE
            if (authState is Authenticated) {
              return const HomePage();
            }
            // LOADING
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },

          // LISTEN FOR ERRORS
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
