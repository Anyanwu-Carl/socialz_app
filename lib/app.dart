import 'package:flutter/material.dart';
import 'package:social_bloc/features/auth/presentation/pages/auth_page.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Media App",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const AuthPage(),
    );
  }
}
