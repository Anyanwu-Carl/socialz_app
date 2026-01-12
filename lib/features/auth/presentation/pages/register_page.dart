import 'package:flutter/material.dart';
import 'package:social_bloc/features/auth/presentation/components/my_button.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? tooglePages;

  const RegisterPage({super.key, required this.tooglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // TEXT CONTROLLER
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

                // CREATE AN ACCOUNT MESSAGE
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // NAME TEXTFIELD
                MyTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  obsureText: false,
                ),

                const SizedBox(height: 15),

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

                const SizedBox(height: 15),

                // CONFIRM PASSWORD TEXTFIELD
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obsureText: true,
                ),

                const SizedBox(height: 25),

                // REGISTER BUTTON
                MyButton(text: "Register", onTap: () {}),

                const SizedBox(height: 25),

                // ALREADY A MEMBER? LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 5),

                    InkWell(
                      onTap: widget.tooglePages,
                      child: const Text(
                        "Login now!",
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
