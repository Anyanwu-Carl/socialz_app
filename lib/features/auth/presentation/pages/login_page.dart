/*
  LOGIN PAGE

  USER CAN LOGIN WITH THEIR EMAIL & PASSWORD

  -----------------------------------------------------

  ONCE THE USER SUCCESSFULLY LOGS IN THEY'LL BE DIRECTED TO THE HOME PAGE

  USER CAN GOTO THE REGISTER PAGE, IF THEY DON"T HAVE AN ACCOUNT YET

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/presentation/components/my_button.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? tooglePages;

  const LoginPage({super.key, required this.tooglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TEXT CONTROLLER
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // LOGIN METHOD
  void login() {
    // PREPARE EMAIL AND PASSWORD
    final String email = emailController.text;
    final String password = passwordController.text;

    // AUTH CUBIT
    final authCubit = context.read<AuthCubit>();

    // ENSURE THAT THE EMAIL AND PASSWORD FIELDS ARE NOT EMPTY
    if (email.isNotEmpty && password.isNotEmpty) {
      // LOGIN
      authCubit.login(email, password);
    }
    // DISPLAY ERROR IF SOME FIELDS ARE EMPTY
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
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
                MyButton(text: "Login", onTap: login),

                const SizedBox(height: 25),

                // NOT A MEMBER? REGISTER NOW!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 5),

                    InkWell(
                      onTap: widget.tooglePages,
                      child: const Text(
                        "Register now!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
