import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/post_controller.dart';

class PostsScreenBody extends GetView<PostController> {
  const PostsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const Center(child: CustomLoader())
              : ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.posts[index].title ?? ''),
                    subtitle: Text(controller.posts[index].body ?? ''),
                  );
                },
              ),
    );
  }
}
