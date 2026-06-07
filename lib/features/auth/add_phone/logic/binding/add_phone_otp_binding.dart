import 'package:get/get.dart';

import '../controller/add_phone_otp_controller.dart';

class AddPhoneOtpBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AddPhoneRepo>(() => AddPhoneRepo(Get.find()));
    Get.lazyPut<AddPhoneOtpController>(() => AddPhoneOtpController(Get.find()));
  }
}
