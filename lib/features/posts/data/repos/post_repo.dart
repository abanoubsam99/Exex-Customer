import 'package:dartz/dartz.dart';
import 'package:evex_user/data/models/error_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../data_sources/post_remote_data_source.dart';
import 'package:evex_user/data/models/post.dart';

class PostRepo {
  final PostRemoteDataSource postRemoteDataSource;

  PostRepo(this.postRemoteDataSource);

  Future<Either<ErrorModel, List<Post>>> getPosts() async {
    try {
      List<Post> result = await postRemoteDataSource.getPosts();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
