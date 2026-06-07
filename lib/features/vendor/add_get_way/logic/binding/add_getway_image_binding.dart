import 'package:evex/feature/vendor/add_get_way/logic/controler/add_getway_image_controler.dart';
import 'package:get/get.dart';

class AddGetwayImageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddGetWayImageControler>(
      () => AddGetWayImageControler(),
    );
  }
}
