import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/presentation/components/my_button.dart';
import 'package:social_bloc/features/auth/presentation/components/my_text_field.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/responsive/constrained_scaffold.dart';

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

  // REGISTER BUTTON FUNCTION
  void register() {
    // PREPARE INFO
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // AUTH CUBIT
    final authCubit = context.read<AuthCubit>();

    // ENSURE FIELDS ARE NOT EMPTY
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      // ENSURE PASSWORDS MATCH
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      }
      // SHOW ERROR - PASSWORDS DO NOT MATCH
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
      }
    }
    // SHOW ERROR - FIELDS ARE EMPTY
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  // DISPOSE CONTROLLERS
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                MyButton(text: "Register", onTap: register),

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
