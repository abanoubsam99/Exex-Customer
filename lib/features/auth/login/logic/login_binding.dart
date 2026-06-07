import 'package:evex_user/features/auth/login/data/data_sources/login_remote_data_source.dart';
import 'package:evex_user/features/auth/login/data/repos/login_repo.dart';
import 'package:evex_user/features/auth/login/logic/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRemoteDataSource>(() => LoginRemoteDataSource(Get.find()));
    Get.lazyPut<LoginRepo>(() => LoginRepo(Get.find()));
    Get.lazyPut<LoginController>(() => LoginController(Get.find()));
  }
}
