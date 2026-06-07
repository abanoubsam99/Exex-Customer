import 'package:evex_user/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/posts_screen_body.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts screen"),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.loginScreen);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PostsScreenBody(),
    );
  }
}
