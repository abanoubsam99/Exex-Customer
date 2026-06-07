import 'package:evex_user/core/location/data/models/city.dart';
import 'package:evex_user/core/location/data/models/governate.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/add_client/data/repo/add_client_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AddClientController extends GetxController {
  AddClientRepo addClientRepo;
  LocationRepo locationRepo;

  AddClientController(this.addClientRepo, this.locationRepo);

  var nameController = TextEditingController();

  //addClient
  addClient() async {
    if (nameController.text.trim().isEmpty) {
      ToastManager.showError('الرجاء ادخال اسم العميل');
      return;
    } else if (selectedgovernnorate.value == null) {
      ToastManager.showError('الرجاء اختيار المحافظة');
      return;
    } else if (selectedCity.value == null) {
      ToastManager.showError('الرجاء اختيار المدينة');
      return;
    }

    startLoading();
    var result = await addClientRepo.addClient(
      name: nameController.text.trim(),
      governorate: selectedgovernnorate.value!.governorateNameAr,
      city: selectedCity.value!.cityNameAr,
    );
    stopLoading();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) async {
        ToastManager.showSuccess(r.message);
        //save userdata in shared pref after update phone
        UserModel? user = UserService.to.currentUser.value;
        if (user != null) {
          user.modelId = r.modelId;
          UserService.to.saveUser(user);
        }
        Get.offAllNamed(Routes.mainScreen);
      },
    );
  }

  var governorates = <Governate>[].obs;
  var cities = <City>[].obs;

  var selectedgovernnorate = Rxn<Governate>();
  var selectedCity = Rxn<City>();

  selectGovernorate(Governate? governorate) {
    selectedgovernnorate.value = governorate;
    selectedCity.value = null;
    if (selectedgovernnorate.value != null) {
      getCities(selectedgovernnorate.value!.id);
    }
  }

  selectCity(City? city) {
    selectedCity.value = city;
  }

  getGovernorates() async {
    var result = await locationRepo.getGovernorates();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        governorates.value = r;
      },
    );
  }

  getCities(int govId) async {
    var result = await locationRepo.getCities(govId);
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        cities.value = r;
      },
    );
  }

  @override
  void onInit() {
    getGovernorates();
    super.onInit();
  }
}
