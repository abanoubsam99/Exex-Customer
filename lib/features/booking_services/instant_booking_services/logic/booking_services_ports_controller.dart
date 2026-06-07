import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/models/get_ports_request.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/models/ports_respond_model.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/features/home/logic/home_controller.dart';
import 'package:get/get.dart';

class BookingServicesPortsController extends GetxController {
  final BookingServicesPortsRepo bookingServicesPortsRepo;
  BookingServicesPortsController(this.bookingServicesPortsRepo);

  HomeController homeController = Get.find();

  var isLoading = false.obs;

  // ScrollController reportsScrollController = ScrollController();
  Rxn<PortsRespondModel> portsRespondModel = Rxn<PortsRespondModel>();
  Rx<GetPortsRequest> getPortsRequest = Rx<GetPortsRequest>(GetPortsRequest());

  Future<void> getAllPortServices() async {
    var res = await bookingServicesPortsRepo.getAllPortServices(
      getPortsRequest.value,
    );
    res.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        portsRespondModel.value = r;
      },
    );
  }

  @override
  void onInit() {
    getPortsRequest.value.portType =
        homeController.selectedBookingPortType.value!.id;
    getAllPortServices();
    ever(homeController.selectedBookingPortType, (callback) {
      getPortsRequest.value.portType =
          homeController.selectedBookingPortType.value!.id;
      getAllPortServices();
    });
    super.onInit();
  }
}
