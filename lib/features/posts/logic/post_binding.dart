import 'package:evex_user/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:evex_user/features/posts/data/repos/post_repo.dart';
import 'package:evex_user/features/posts/logic/post_controller.dart';
import 'package:get/get.dart';

class PostBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDataSource>(() => PostRemoteDataSource(Get.find()));
    Get.lazyPut<PostRepo>(() => PostRepo(Get.find()));
    Get.lazyPut<PostController>(() => PostController(Get.find()));
  }
}
