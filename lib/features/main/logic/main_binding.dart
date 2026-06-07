import 'package:evex_user/features/home/logic/home_binding.dart';
import 'package:evex_user/features/main/logic/main_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();

    Get.lazyPut<MainController>(() => MainController());
  }
}
