import 'package:evex_user/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:evex_user/features/auth/register/data/repos/register_repo.dart';
import 'package:evex_user/features/auth/register/logic/register_controller.dart';
import 'package:get/get.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRemoteDataSource>(() => RegisterRemoteDataSource(Get.find()));
    Get.lazyPut<RegisterRepo>(() => RegisterRepo(Get.find()));
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find()));
  }
}
