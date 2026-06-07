import 'package:evex_user/features/auth/add_phone/data/data_sources/add_phone_data_source.dart';
import 'package:evex_user/features/auth/add_phone/data/repo/add_phone_repo.dart';
import 'package:get/get.dart';

import '../controller/add_phone_controller.dart';

class AddPhoneBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPhoneRemoteDataSource>(
      () => AddPhoneRemoteDataSource(Get.find()),
    );
    Get.lazyPut<AddPhoneRepo>(() => AddPhoneRepo(Get.find()));
    Get.lazyPut<AddPhoneController>(() => AddPhoneController(Get.find()));
  }
}
