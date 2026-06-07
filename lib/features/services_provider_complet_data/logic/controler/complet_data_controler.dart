import 'dart:convert';

import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/toast_manager.dart';
import 'package:evex/core/services/cache/cash_helper.dart';
import 'package:evex/core/services/cache/cash_keys.dart';
import 'package:evex/core/services/location_service/governates/city_model/city_model.dart';
import 'package:evex/core/services/location_service/governates/governates/governates.dart';
import 'package:evex/core/services/location_service/location_service.dart';
import 'package:evex/core/services/user_service/user_serivces.dart';

import 'package:evex/feature/services_provider_complet_data/data/repo/complet_service_provider_repo.dart';
import 'package:evex/feature/vendor/add_get_way/data/repo/ports_repo.dart.dart';
import 'package:evex/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../vendor/add_get_way/data/model/add_port_model/add_port_request_model/port_type.dart';

class CompletDataControler extends GetxController {
  // final List services = [
  //   "مأذون شرعي",
  //   "مصورين",
  //   "قاعة أفراح",
  //   "كنيسة",
  //   "صالون رجالي",
  //   "بدل رجالي",
  //   "فساتين أفراح",
  //   "ميكاب أرتيست",
  //   "إكسسورات",
  //   "ورود"
  // ];

  RxList<PortType> services = RxList<PortType>([]);

  GlobalKey<FormState> dataFormKey = GlobalKey();
  GlobalKey<FormState> locationDataFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> linksFormKey = GlobalKey();
  GlobalKey<FormState> addtioninformationFormKey = GlobalKey();
  RxBool isLoading = false.obs;
  // المتغير الديناميكي لتتبع العنصر النشط
  RxInt index = (-1).obs;

  // تحديث الحالة عند النقر على العنصر
  void tiggelservice(int i) {
    index.value = i;
    // debugPrint(serviceType);
  }

  //  ------------------------
  getlocation() async {
    // await LocationService().getPosition();
    LocationResult? result = await LocationService().getPosition();
    Placemark? m = result?.placemark;
    position.value = result?.position;

    if (m != null) {
      loc.value =
          '${m.administrativeArea} / ${m.subAdministrativeArea} / ${m.street}';
    }
  }

  TextEditingController fristnameController = TextEditingController();
  TextEditingController middelnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addtionlinkController = TextEditingController();
  TextEditingController addtioninfoController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController addressDetails = TextEditingController();

  CityModel? citycontroller;
  RxnString selectedCityName = RxnString();
  Governate? governoratecontroller;
  String? selectedGovernateName;
  RxString serviceType = ''.obs;

  CompletServiceProviderRepo completServiceProviderRepo =
      CompletServiceProviderRepo();

  Future<void> getServices() async {
    startLoading();
    var res = await portsRepo.getPortTypes();
    stopLoading();
    res.fold((l) {
      ToastManager.showError(l);
    }, (r) {
      services.value = r;
    });
  }

  Future<void> completVanderData() async {
    var userModel = await CashHelper.getData(CacheKeys.userModel);
    String userId = "";

    if (userModel != null) {
      // فك ترميز JSON للحصول على userId
      var decodedData = json.decode(userModel);
      userId =
          decodedData['id'] ?? ""; // استبدل 'id' باسم المفتاح الخاص بـ userId
    }
    startLoading();
    var result = await completServiceProviderRepo.completedata(
      name:
          "${fristnameController.text.trim()} ${middelnameController.text.trim()} ${lastnameController.text.trim()}",
      governorate: selectedGovernateName ?? "",
      serviceType: serviceType.value,
      gps: loc.value,
      address: addressDetails.text.trim(),
      link: linkController.text.trim(),
      additionalLink: addtionlinkController.text.trim(),
      additionalInfo: addtioninfoController.text.trim(),
      city: selectedCityName.value ?? "",
    );
    stopLoading();
    result.fold((l) {
      ToastManager.showError(l.message);
    }, (r) async {
      ToastManager.showSuccess(r.message ?? "", true);

      await CashHelper.setData(CacheKeys.userModel, json.encode(r.toJson()));
      UserService.to.currentUser?.value?.modelId = r.modelId;
      UserService().logout();
      // Get.offAllNamed(Routes.serviceProviderHome);
    });
  }

  // -------pageview------------------------
  RxInt currentPage = 0.obs;
  late final PageController pageController;

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController();
    getGovernates();
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    currentPage.value = index;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    if (index == 1 && services.isEmpty) {
      getServices();
    } else if (index == 2) {
      getlocation();
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      goToPage(currentPage.value - 1);
    }
  }

  var loc = "".obs;
  Rxn<Position> position = Rxn<Position>();

  PortsRepo portsRepo = PortsRepo();

  getGovernates() async {
    isLoading.value = true;
    var res = await portsRepo.getGovernates();
    res.fold((l) {
      isLoading.value = false;
      ToastManager.showError(l);
    }, (r) {
      governates.value = r;
      isLoading.value = false;
    });
  }

  getCities(String gName, [bool isWorking = false]) async {
    startLoading();
    var res = await portsRepo.getCities(
        governates.value.firstWhere((g) => g.governorateNameAr == gName).id!);
    res.fold((l) {
      stopLoading();
      ToastManager.showError(l);
    }, (r) {
      stopLoading();
      if (isWorking) {
        cities.value = r;
      } else {
        cities.value = r;
      }
    });
  }

  RxList<Governate> governates = RxList<Governate>([]);
  RxList<CityModel> cities = RxList<CityModel>([]);
}
