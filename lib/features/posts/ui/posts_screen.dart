import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:flutter/material.dart';

import 'widgets/posts_screen_body.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts screen"),
        actions: [
          IconButton(
            onPressed: () {
              NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const PostsScreenBody(),
    );
  }
}
