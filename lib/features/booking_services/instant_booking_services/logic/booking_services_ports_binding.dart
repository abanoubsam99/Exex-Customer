import 'package:evex_user/features/booking_services/instant_booking_services/data/datasources/booking_servicies_ports_remote_data_source.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/logic/booking_services_ports_controller.dart';
import 'package:get/get.dart';

class BookingServicesPortsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingServiciesPortsRemoteDataSource>(
      () => BookingServiciesPortsRemoteDataSource(Get.find()),
    );
    Get.lazyPut<BookingServicesPortsRepo>(
      () => BookingServicesPortsRepo(Get.find()),
    );
    Get.lazyPut<BookingServicesPortsController>(
      () => BookingServicesPortsController(Get.find()),
    );
  }
}
