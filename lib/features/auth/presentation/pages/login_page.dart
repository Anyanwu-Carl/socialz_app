/*
  LOGIN PAGE

  USER CAN LOGIN WITH THEIR EMAIL & PASSWORD

  -----------------------------------------------------

  ONCE THE USER SUCCESSFULLY LOGS IN THEY'LL BE DIRECTED TO THE HOME PAGE

  USER CAN GOTO THE REGISTER PAGE, IF THEY DON"T HAVE AN ACCOUNT YET

*/

import 'package:flutter/material.dart';
import 'package:social_bloc/features/auth/presentation/components/my_button.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TEXT CONTROLLER
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                // WELCOME BACK TEXT
                Text(
                  "Welcome back, You've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // EMAIL TEXTFIELD
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  obsureText: false,
                ),

                const SizedBox(height: 15),

                // PASSWORD TEXTFIELD
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obsureText: true,
                ),

                const SizedBox(height: 25),

                // LOGIN BUTTON
                MyButton(text: "Login", onTap: () {}),

                const SizedBox(height: 25),

                // NOT A MEMBER? REGISTER NOW!
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    SizedBox(width: 5),
                    Text(
                      "Register now!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
