import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/post.dart';

class PostRepo {
  Future<List<Post>?> getPosts() async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.baseUrl2}${AppEndpoints.posts}',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List).map((e) => Post.fromJson(e)).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
