import 'package:get/get.dart';

import '../controller/forget_password_otp_controller.dart';


class ForgetPasswordOtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordOtpController>(
      () => ForgetPasswordOtpController(),
    );
  }
}
