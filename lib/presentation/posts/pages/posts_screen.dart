import 'package:evexcustomer/app/Helper/NavigationHelper.dart';
import 'package:evexcustomer/presentation/home/pages/home_screen.dart';
import 'package:evexcustomer/presentation/login/pages/login_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/posts_screen_body.dart';

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
              NavigationHelper.pushReplacement(context, LoginScreen());
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PostsScreenBody(),
    );
  }
}

