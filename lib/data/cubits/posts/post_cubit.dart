import 'package:evex_user/features/posts/data/repos/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo _postRepo;

  PostCubit(this._postRepo) : super(PostInitial());

  Future<void> getPosts() async {
    emit(PostLoading());
    final result = await _postRepo.getPosts();
    result.fold(
      (error) => emit(PostError(error.message)),
      (posts) => emit(PostSuccess(posts)),
    );
  }
}
