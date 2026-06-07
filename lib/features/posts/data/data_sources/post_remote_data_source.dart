import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/app_endpoints.dart' show AppEndpoints;
import '../models/post.dart';

part 'post_remote_data_source.g.dart';

@RestApi(baseUrl: AppEndpoints.baseUrl2)
abstract class PostRemoteDataSource {
  factory PostRemoteDataSource(Dio dio) = _PostRemoteDataSource;

  @GET(AppEndpoints.posts)
  Future<List<Post>> getPosts();
}
