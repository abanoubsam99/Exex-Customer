import 'package:flutter/material.dart';


class PostsScreenBody  extends StatelessWidget {
  const PostsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text( 'title'),
          subtitle: Text( 'body'),
        );
      },
    );
  }
}
