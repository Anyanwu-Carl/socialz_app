import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:social_bloc/firebase_options.dart';
import 'package:social_bloc/themes/light_mode.dart';

void main() async {
  // FIREBASE INITIALIZATION
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // RUN APP
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Media App",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const LoginPage(),
    );
  }
}
