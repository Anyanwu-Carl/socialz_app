/*

-- Dark Mode
-- Blocked Users
-- Account Settings

 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/responsive/constrained_scaffold.dart';
import 'package:social_bloc/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // Dark mode switch
    bool isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListTile(
        title: const Text("Dark Mode"),
        trailing: CupertinoSwitch(
          value: isDarkMode,
          onChanged: (value) {
            themeCubit.toggleTheme();
          },
        ),
      ),
    );
  }
}
