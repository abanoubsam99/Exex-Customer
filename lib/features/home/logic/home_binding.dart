import 'package:evex_user/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:evex_user/features/home/data/repos/home_repo.dart';
import 'package:evex_user/features/home/logic/home_controller.dart';
import 'package:evex_user/features/profile/logic/profile_binding.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    ProfileBinding().dependencies();
    Get.lazyPut<HomeRemoteDataSource>(() => HomeRemoteDataSource(Get.find()));
    Get.lazyPut<HomeRepo>(() => HomeRepo(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
