import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/data/cubits/posts/post_cubit.dart';
import 'package:evex_user/data/cubits/posts/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsScreenBody extends StatelessWidget {
  const PostsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CustomLoader());
        }
        if (state is PostSuccess) {
          if (state.posts.isEmpty) {
            return const EmptyListWidget();
          }
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.posts[index].title ?? ''),
                subtitle: Text(state.posts[index].body ?? ''),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
