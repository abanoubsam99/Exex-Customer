import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/toast_manager.dart';
import 'package:evex/core/services/location_service/governates/city_model/city_model.dart';
import 'package:evex/core/services/location_service/governates/governates/governates.dart';
import 'package:evex/core/services/user_service/user_serivces.dart';
import 'package:evex/feature/profile/data/models/profile.dart';
import 'package:evex/feature/profile/data/repos/profile_repo.dart';
import 'package:evex/feature/vendor/add_get_way/data/repo/ports_repo.dart.dart';
import 'package:evex/feature/vendor/add_reservation/logic/controller/client_controller.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class ProfileController extends GetxController {
  ProfileRepo repo = ProfileRepo();
  RxBool isLoading = false.obs;
  Rxn<Profile> profile = Rxn<Profile>();

  Future<void> getProfile() async {
    isLoading.value = true;
    var res = await repo.getProfile();
    isLoading.value = false;
    res.fold((errMSG) {
      ToastManager.showError(errMSG);
    }, (r) async {
      profile.value = r;
    });
  }

  Future<void> updateProfile() async {
    startLoading();
    String vendorName = vendorNameController.text
        .split(' ')
        .where((element) => element.trim().isNotEmpty)
        .toList()
        .join(' ');

    var res = await repo.updateProfile(
      Profile(
        companyKey: profile.value?.companyKey,
        name: vendorName,
        governorate: selectedGovernateName.value,
        city: selectedCity.value,
        address: addressController.text,
        link: link1Controller.text,
        additionalLink: link2Controller.text,
        additionalInfo: notesController.text,
      ),
    );
    stopLoading();
    res.fold((errMSG) {
      ToastManager.showError(errMSG);
    }, (r) async {
      Get.back();
      ToastManager.showSuccess(r, true);
      getProfile();
    });
  }

  Future<void> changePassword() async {
    startLoading();
    var res = await repo.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    stopLoading();
    res.fold((errMSG) {
      ToastManager.showError(errMSG);
    }, (r) async {
      Get.back();
      ToastManager.showSuccess(r, true);
    });
  }

  // TextEditingControllers
  final vendorNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final link1Controller = TextEditingController();
  final link2Controller = TextEditingController();
  final notesController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //form keys
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  // Dropdowns
  var governates = <Governate>[].obs;
  var cities = <CityModel>[].obs;

  RxnString selectedGovernateName = RxnString();
  RxnString selectedCity = RxnString();

  Future<void> prepareEditProfile() async {
    await getGovernates();
    selectedGovernateName.value = profile.value?.governorate;
    await getCities(gName: selectedGovernateName.value!);
    selectedCity.value = profile.value?.city;

    loadProfileData();
  }

  void loadProfileData() {
    vendorNameController.text = profile.value?.name ?? '';
    emailController.text = profile.value?.email ?? '';
    addressController.text = profile.value?.address ?? '';
    link1Controller.text = profile.value?.link ?? '';
    link2Controller.text = profile.value?.additionalLink ?? '';
    notesController.text = profile.value?.additionalInfo ?? '';

    // selectedGovernateName.value = profile.value?.governorate;
    // selectedCity.value = profile.value?.city;
  }

  PortsRepo portsRepo = PortsRepo();
  getGovernates() async {
    isLoading.value = true;
    var res = await portsRepo.getGovernates();
    res.fold((l) {
      isLoading.value = false;
      buildConnectionErrorDialog(() => getGovernates());
    }, (r) async {
      governates.value = r;
      isLoading.value = false;
    });
  }

  getCities(
      {required String gName,
      bool isWorking = false,
      withLoading = true}) async {
    if (withLoading) startLoading();
    var res = await portsRepo.getCities(
        governates.value.firstWhere((g) => g.governorateNameAr == gName).id!);
    res.fold((l) {
      if (withLoading) stopLoading();
      buildConnectionErrorDialog(() => getCities(gName: gName));
    }, (r) {
      if (withLoading) stopLoading();
      cities.value = r;
    });
  }

    Future<void> deleteAccount(String email) async {
    if (UserService.to.currentUser?.value?.userData?.email != email) {
      ToastManager.showError('البريد الإلكتروني غير صحيح');
      return;
    } else {
      startLoading();
      var res = await repo.deleteAccount(email);
      stopLoading();
      res.fold(
        (l) {
          ToastManager.showError(l);
        },
        (r) {
          ToastManager.showSuccess('تم حذف الحساب بنجاح',true);
          UserService.to.logout();
        },
      );
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
