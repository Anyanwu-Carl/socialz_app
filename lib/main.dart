import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_bloc/app.dart';
import 'package:social_bloc/config/firebase_options.dart';

void main() async {
  // FIREBASE INITIALIZATION
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // RUN APP
  runApp(MyApp());
}
