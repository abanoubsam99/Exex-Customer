import 'package:evex_user/features/auth/reset_password/data/data_sources/forget_password_data_source.dart';
import 'package:evex_user/features/auth/reset_password/data/repo/forget_password_repo.dart';
import 'package:get/get.dart';

import '../controller/forget_password_controller.dart';

class ForgetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordRemoteDataSource>(
      () => ForgetPasswordRemoteDataSource(Get.find()),
    );
    Get.lazyPut<ForgetPasswordRepo>(() => ForgetPasswordRepo(Get.find()));
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(Get.find()),
    );
  }
}
