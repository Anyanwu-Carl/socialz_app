/*

This page will display a tab bar to show

- List of followers
- List of following

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_bloc/features/profile/presentation/component/user_tile.dart';
import 'package:social_bloc/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_bloc/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        // APP BAR
        appBar: AppBar(
          // Tab bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),

        // Tab bar view
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers", context),
            _buildUserList(following, "No following", context),
          ],
        ),
      ),
    );
  }

  // Build user list, given a list of profile uids
  Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
  ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // Get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // User loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  }
                  // User loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading..."));
                  }
                  // User not found
                  else {
                    return const ListTile(title: Text("User not found"));
                  }
                },
              );
            },
          );
  }
}
