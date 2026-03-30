import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_bloc/features/home/presentation/components/my_drawer_tile.dart';
import 'package:social_bloc/features/profile/presentation/pages/profile_page.dart';
import 'package:social_bloc/features/search/presentation/pages/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: DrawerHeader(
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // HOME TILE
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              // PROFILE TILE
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  // POP DRAWER
                  Navigator.pop(context);

                  // GET CURRENT USER ID
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  // NAVIGATE TO PROFILE PAGE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

              // SEARCH TILE
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),

              // SETTINGS TILE
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SettingsPage(),
                  //   ),
                  // );
                },
              ),

              const Spacer(),

              // LOGOUT TILE
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
