import 'dart:convert';

import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/toast_manager.dart';
import 'package:evex/core/services/location_service/governates/city_model/city_model.dart';
import 'package:evex/core/services/location_service/governates/governates/governates.dart';
import 'package:evex/core/services/location_service/location_service.dart';
import 'package:evex/core/services/user_service/user_serivces.dart';
import 'package:evex/feature/vendor/add_get_way/data/model/add_port_model/add_port_request_model/add_port_request_model.dart';
import 'package:evex/feature/vendor/add_get_way/data/model/add_port_model/add_port_request_model/port_type.dart';
import 'package:evex/feature/vendor/add_get_way/data/model/workArea/work_area.dart';
import 'package:evex/feature/vendor/add_get_way/data/repo/add_get_way_repo.dart';
import 'package:evex/feature/vendor/add_get_way/data/repo/ports_repo.dart.dart';
import 'package:evex/feature/vendor/vendor_home_feature/logic/controller/home_controller.dart';
import 'package:evex/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AddGetwayController extends GetxController {
//-----------------------------pageview-----------------------------------
  RxInt currentPage = 0.obs;
  late final PageController pageController;

  @override
  void onInit() async {
    super.onInit();
    getPorts();

    pageController = PageController();
  }

  PortsRepo portsRepo = PortsRepo();
  Future<void> getPortData(int id) async {
    isLoading.value = true;
    var res = await portsRepo.getPortById(id);
    await res.fold((l) {
      isLoading.value = false;
      ToastManager.showError(l);
    }, (r) async {
      initData = r;
      typeofGetway = ports.firstWhere((element) => element.id == r.portTypeId);
      gatewayName.text = r.portName ?? "";
      r.phoneNumber1 != null ? phone1.text = r.phoneNumber1! : null;
      r.phoneNumber2 != null ? phone2.text = r.phoneNumber2! : null;

      addressDetails.text = r.address ?? "";
      selectedGovernate = r.governorate ?? "";

      selectedCity?.value = r.city ?? "";
      selectedCity?.value = r.city!;
      percentageDepositController.text = r.percentageDeposit.toString();
      numberofday.value = r.minimumDays ?? 0;
      datebook.text = r.finalDate ?? "";
      numberPerDay = r.reservationRate ?? 0;
      allowedPersonNumber.text = r.numberAllowed.toString();
      loc.value = r.gps ?? "";
      starttime.text = r.openingTime ?? "";
      endtime.text = r.closingTime ?? "";
      if ((r.workDays ?? "").contains('كل ايام الاسبوع')) {
        selday = [0, 1, 2, 3, 4, 5, 6];
      } else {
        List<dynamic> l = (json.decode(r.workDays ?? '[]')).toList();

        l.where((dynamic e) {
          if (e != null) selday.add(days.indexOf(e));
          return false;
        }).toList();
      }

      isLoading.value = false;
      workAreaData.value =
          WorkAreaData(workAreaViewModels: r.workAreaViewModels ?? []);
      await getGovernates();
      await getCities(gName: r.governorate ?? "", withLoading: false);
    });
  }

  Future<void> getPorts() async {
    isLoading.value = true;
    var res = await portsRepo.getPortTypes();
    res.fold((l) {
      isLoading.value = false;
      ToastManager.showError(l);
    }, (r) {
      ports.value = r;
      if (Get.arguments != null) {
        getPortData(Get.arguments);
      } else {
        isLoading.value = false;
      }
    });
  }

  Future<void> getGovernates() async {
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

  Future<void> getCities(
      {required String gName,
      bool isWorking = false,
      withLoading = true}) async {
    if (withLoading) startLoading();
    var res = await portsRepo.getCities(
        governates.value.firstWhere((g) => g.governorateNameAr == gName).id!);
    res.fold((l) {
      if (withLoading) stopLoading();
      ToastManager.showError(l);
    }, (r) {
      if (withLoading) stopLoading();

      isSelectedAllCity.value = false;
      print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
      print(isSelectedAllCity.value);

      if (isWorking) {
        workingCities.value = r;
      } else {
        cities.value = r;
      }
    });
  }

  AddPortRequestModel? initData;
  RxList<PortType> ports = RxList<PortType>([]);
  RxBool isSelectedAllCity = false.obs;
  RxList<Governate> governates = RxList<Governate>([]);
  RxList<CityModel> cities = RxList<CityModel>([]);
  RxList<CityModel> workingCities = RxList<CityModel>([]);
  RxBool isLoading = false.obs;

  void goToPage(int index) {
    if (index == 1 || index == 3) {
      if (governates.isEmpty) getGovernates();
    }
    if (index == 1) {
      getlocation();
    }
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    currentPage.value = index;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      goToPage(currentPage.value - 1);
    }
  }
  //-------------------------------end page view ---------------------------------------

  ///--------------------------GET LOCATION -----------------------------------

  Future<void> getlocation() async {
    // await LocationService().getPosition();
    LocationResult? result = await LocationService().getPosition();
    Placemark? m = result?.placemark;
    position.value = result?.position;
    if (m != null) {
      loc.value =
          '${m.administrativeArea} / ${m.subAdministrativeArea} / ${m.street}';
    }
  }

  //------------------------------information getway varibel----------------------------------------

  TextEditingController gatewayName = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  GlobalKey<FormState> infromtionGetwayKey = GlobalKey();
  GlobalKey<FormState> locationDataFormKey = GlobalKey<FormState>();
  TextEditingController addressDetails = TextEditingController();
  TextEditingController allowedPersonNumber = TextEditingController();
  String? selectedGovernate;
  RxString? selectedCity = RxString('');
  PortType? typeofGetway;
  List<String> days = [
    'السبت',
    'الاحد',
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخميس',
    'الجمعة',
  ];

//------------------------------WORK DETAILS VARIBEL ----------------------------
  TextEditingController percentageDepositController = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController endtime = TextEditingController();
  TextEditingController profit = TextEditingController();
  final GlobalKey<FormState> workderails = GlobalKey();
  TextEditingController datebook = TextEditingController();
  int numberPerDay = 1;

  ///---------------- CHOOSE DAYS --------------
  List selday = [].obs;

  void togeelui(int index) {
    if (selday.contains(index)) {
      selday.remove(index);
    } else {
      selday.add(index);
    }
    update();
  }

  //--------------------  NUMBER OF DAYS -------------------

  RxInt numberofday = 1.obs;

  void plusday() {
    numberofday++;
  }

  void minusday() {
    if (numberofday > 1) numberofday--;
  }

// -----------loccationavailbelforWork -----------------------------------
  GlobalKey<FormState> loctionAvailnel = GlobalKey();
  String? currentSelectedGovernate;
  RxList<String> currentSelectedCities = RxList<String>([]);

  Rxn<WorkAreaData?> workAreaData =
      Rxn<WorkAreaData>(WorkAreaData(workAreaViewModels: []));
  // addWorkArea() async {
  //   // workAreaData.value ??= WorkAreaData();

  //   workAreaData.value?.workAreaViewModels?.add(

  //     WorkAreaViewModel(
  //       city: currentSelectedCity, governorate: currentSelectedGovernate)

  //       );
  // update();
  // }

  void toggelcity(index) {
    // selcity = index;
    update();
  }

  var loc = "".obs;
  Rxn<Position> position = Rxn<Position>();
  //----------------------------------------request ------------------------

  AddGetWayRepo addGetWayRepo = AddGetWayRepo();

  Future<void> addport() async {
    startLoading();
    var res = await addGetWayRepo.addPort(
        id: initData?.id,
        addPortModel: AddPortRequestModel(
          accepted: initData?.accepted ?? false,
          id: initData?.id,
          portTypeId: typeofGetway!.id,
          portName: gatewayName.text,
          phoneNumber1: phone1.text,
          phoneNumber2: phone2.text.isEmpty ? null : phone2.text,
          address: addressDetails.text,
          city: selectedCity?.value ?? "",
          governorate: selectedGovernate,
          percentageDeposit:
              (double.tryParse(percentageDepositController.text) ?? 0).toInt(),
          minimumDays: numberofday.value,
          finalDate: datebook.text,
          reservationRate: numberPerDay,
          workDays: json.encode(List.generate(selday.length, (index) {
            if (selday[index] >= 0) return days[selday[index]];
          })),
          openingTime: starttime.text.isEmpty ? null : starttime.text,
          closingTime: endtime.text.isEmpty ? null : endtime.text,
          workAreaViewModels: workAreaData.value?.workAreaViewModels,
          gps: loc.value.isEmpty ? null : loc.value,
          userId: UserService.to.currentUser!.value!.modelId.toString(),
          numberAllowed: allowedPersonNumber.text.isEmpty
              ? null
              : int.parse(allowedPersonNumber.text),

          // userId: 1,
          // workDays: selday,
          // numberAllowed: int.parse(allowedPersonNumber.text),
          // address:
        ));

    stopLoading();
    res.fold((l) {
      ToastManager.showSuccess(l.message, false);
    }, (r) {
      // selectedCity = RxString("");
      // governates = RxList([]);

      // cities = RxList([]);
      // currentSelectedGovernate = null;

      ToastManager.showSuccess(r.message, true);
      if (Get.isRegistered<VendorHomeController>()) {
        Get.find<VendorHomeController>().getUserHomeData();
      }
      // Get.offAllNamed(Routes.serviceProviderHome);
      Get.offNamed(Routes.addGetWayimages,
          arguments: {'isEdit': true, 'portId': r.modelId});
    });
  }
}
