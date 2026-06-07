import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/home/data/models/port_category_with_port_types.dart';
import 'package:evex_user/features/home/data/models/special_offer.dart';
import 'package:evex_user/features/home/data/repos/home_repo.dart';
import 'package:evex_user/features/profile/logic/profile_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRepo homeRepo;
  HomeController(this.homeRepo);

  var isLoading = false.obs;

  RxList<PortCategoryWithPortTypes> ports = RxList();

  RxList<PortCategoryWithPortTypes> bookingPorts = RxList();
  RxList<PortCategoryWithPortTypes> paymentPorts = RxList();

  Rxn<PortCategoryWithPortTypes> selectedBookingPort = Rxn();
  Rxn<PortTypeDto> selectedBookingPortType = Rxn();

  Rxn<PortCategoryWithPortTypes> selectedPaymentPort = Rxn();
  Rxn<PortTypeDto> selectedPaymentPortType = Rxn();

  getHomeUserAppInfo() async {
    isLoading.value = true;
    final result = await homeRepo.getHomeUserAppInfo();
    isLoading.value = false;
    result.fold(
      (error) {
        ToastManager.showError(error.message);
      },
      (r) {
        ports.value = r;
        for (var element in ports) {
          if (element.subscriptionType == 0) {
            bookingPorts.add(element);
          } else if (element.subscriptionType == 1) {
            paymentPorts.add(element);
          }
        }
      },
    );
  }

  var getSpecialOffersLoading = false.obs;

  RxList<SpecialOffer> specialOffers = RxList();

  getSpecialOffers() async {
    getSpecialOffersLoading.value = true;
    final result = await homeRepo.getSpecialOffers();
    getSpecialOffersLoading.value = false;
    result.fold(
      (error) {
        ToastManager.showError(error.message);
      },
      (r) {
        specialOffers.value = r;
      },
    );
  }

  @override
  void onInit() {
    getHomeUserAppInfo();
    getSpecialOffers();
    getUserData();
    super.onInit();
  }

  void getUserData() {
    Get.find<ProfileController>(); //oninit start
  }
}
