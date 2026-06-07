import 'package:evex_user/features/booking_services/booking_service_details/data/datasources/port_services_remote_data_source.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/repos/port_services_repo.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_controller.dart';
import 'package:get/get.dart';

class InstanceBookingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortServicesRemoteDataSource>(
      () => PortServicesRemoteDataSource(Get.find()),
    );
    Get.lazyPut<PortServicesRepo>(() => PortServicesRepo(Get.find()));
    Get.lazyPut<PortServicesController>(
      () => PortServicesController(Get.find()),
    );
  }
}
