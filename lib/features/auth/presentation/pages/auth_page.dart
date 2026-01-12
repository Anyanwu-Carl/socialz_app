/*

  AUTH PAGE DETERMINES WHAT PAGE TO SHOW ON APP START-UP

*/

import 'package:flutter/material.dart';
import 'package:social_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:social_bloc/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // INITIALLY SHOW LOGIN PAGE

  bool showLoginPage = true;

  // TOOGLE BETWEEN PAGES
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(tooglePages: togglePages);
    } else {
      return RegisterPage(tooglePages: togglePages);
    }
  }
}
