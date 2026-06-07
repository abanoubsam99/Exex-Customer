import 'package:evex_user/data/repos/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo _postRepo;

  PostCubit(this._postRepo) : super(PostInitial());

  Future<void> getPosts() async {
    emit(PostLoading());
    final posts = await _postRepo.getPosts();
    if (posts != null) {
      emit(PostSuccess(posts));
    } else {
      emit(PostError('حدث خطأ في تحميل المنشورات'));
    }
  }
}
