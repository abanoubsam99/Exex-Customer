import 'dart:io';
import 'dart:math';

import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:evex_user/core/constants/alice.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/helpers/cash_helper.dart';
import 'package:evex_user/core/location/data/models/city.dart';
import 'package:evex_user/core/location/data/models/governate.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:flutter/material.dart';

import 'package:evex_user/features/profile/data/repos/profile_repo.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  ProfileController(this.profileRepo, this.locationRepo);
  ProfileRepo profileRepo;
  LocationRepo locationRepo;
  RxBool isLoading = false.obs;
  Rxn<UserViewModel> profile = Rxn<UserViewModel>();

  Future<void> getProfile() async {
    isLoading.value = true;
    var res = await profileRepo.getProfile();
    isLoading.value = false;
    res.fold(
      (error) {
        ToastManager.showError(error.message);
      },
      (r) async {
        profile.value = r;
        // UserService.to.updateUser(r);
      },
    );
  }

  // Future<void> updateProfile() async {
  //   startLoading();
  //   String vendorName = vendorNameController.text
  //       .split(' ')
  //       .where((element) => element.trim().isNotEmpty)
  //       .toList()
  //       .join(' ');

  //   var res = await repo.updateProfile(
  //     Profile(
  //       companyKey: profile.value?.companyKey,
  //       name: vendorName,
  //       governorate: selectedGovernateName.value,
  //       city: selectedCity.value,
  //       address: addressController.text,
  //       link: link1Controller.text,
  //       additionalLink: link2Controller.text,
  //       additionalInfo: notesController.text,
  //     ),
  //   );
  //   stopLoading();
  //   res.fold((errMSG) {
  //     ToastManager.showError(errMSG);
  //   }, (r) async {
  //     Get.back();
  //     ToastManager.showSuccess(r, true);
  //     getProfile();
  //   });
  // }

  // Future<void> changePassword() async {
  //   startLoading();
  //   var res = await repo.changePassword(
  //     currentPassword: currentPasswordController.text,
  //     newPassword: newPasswordController.text,
  //     confirmPassword: confirmPasswordController.text,
  //   );
  //   stopLoading();
  //   res.fold((errMSG) {
  //     ToastManager.showError(errMSG);
  //   }, (r) async {
  //     Get.back();
  //     ToastManager.showSuccess(r, true);
  //   });
  // }

  // // TextEditingControllers
  // final vendorNameController = TextEditingController();
  // final emailController = TextEditingController();
  // final addressController = TextEditingController();
  // final link1Controller = TextEditingController();
  // final link2Controller = TextEditingController();
  // final notesController = TextEditingController();

  // final currentPasswordController = TextEditingController();
  // final newPasswordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();

  // //form keys
  // GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  // // Dropdowns
  // var governates = <Governate>[].obs;
  // var cities = <CityModel>[].obs;

  // RxnString selectedGovernateName = RxnString();
  // RxnString selectedCity = RxnString();

  // Future<void> prepareEditProfile() async {
  //   await getGovernates();
  //   selectedGovernateName.value = profile.value?.governorate;
  //   await getCities(gName: selectedGovernateName.value!);
  //   selectedCity.value = profile.value?.city;

  //   loadProfileData();
  // }

  // void loadProfileData() {
  //   vendorNameController.text = profile.value?.name ?? '';
  //   emailController.text = profile.value?.email ?? '';
  //   addressController.text = profile.value?.address ?? '';
  //   link1Controller.text = profile.value?.link ?? '';
  //   link2Controller.text = profile.value?.additionalLink ?? '';
  //   notesController.text = profile.value?.additionalInfo ?? '';

  //   // selectedGovernateName.value = profile.value?.governorate;
  //   // selectedCity.value = profile.value?.city;
  // }

  // PortsRepo portsRepo = PortsRepo();
  // getGovernates() async {
  //   isLoading.value = true;
  //   var res = await portsRepo.getGovernates();
  //   res.fold((l) {
  //     isLoading.value = false;
  //     buildConnectionErrorDialog(() => getGovernates());
  //   }, (r) async {
  //     governates.value = r;
  //     isLoading.value = false;
  //   });
  // }

  // getCities(
  //     {required String gName,
  //     bool isWorking = false,
  //     withLoading = true}) async {
  //   if (withLoading) startLoading();
  //   var res = await portsRepo.getCities(
  //       governates.value.firstWhere((g) => g.governorateNameAr == gName).id!);
  //   res.fold((l) {
  //     if (withLoading) stopLoading();
  //     buildConnectionErrorDialog(() => getCities(gName: gName));
  //   }, (r) {
  //     if (withLoading) stopLoading();
  //     cities.value = r;
  //   });
  // }

  //// Edit Profile

  // TextEditingControllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //form keys
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  // Dropdowns
  var governates = <Governate>[].obs;
  var cities = <City>[].obs;

  RxnString selectedGovernate = RxnString();
  RxnString selectedCity = RxnString();

  Future<void> prepareEditProfile() async {
    startLoading();
    var res = await locationRepo.getGovernorates();
    stopLoading();
    res.fold(
      (l) {
        ToastManager.showError(l.message);
        return;
      },
      (r) {
        governates.value = r;
      },
    );

    selectedGovernate.value = profile.value?.governorate;

    getCities(selectedGovernate.value!);
    selectedCity.value = profile.value?.city;

    loadProfileData();
  }

  getCities(String gName) async {
    startLoading();
    var cityRes = await locationRepo.getCities(
      governates.value.firstWhere((g) => g.governorateNameAr == gName).id,
    );
    stopLoading();
    cityRes.fold(
      (l) {
        ToastManager.showError(l.message);
        return;
      },
      (r) {
        cities.value = r;
      },
    );
  }

  final Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<FormData> _buildFormData() async {
    return FormData.fromMap({
      'Name': nameController.text.trim(),
      'Governorate': selectedGovernate.value,
      'City': selectedCity.value,
      if (selectedImage.value != null)
        'image': await MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.uri.pathSegments.last,
        ),
    });
  }

  Future<void> updateClient() async {
    print('Selected image: ${selectedImage.value}'); // check if null
    print(
      'Image exists: ${selectedImage.value?.existsSync()}',
    ); // check if file exists

    var formData = await _buildFormData();
    print('Files count: ${formData.files.length}'); // check if file was added

    if (formData.files.isNotEmpty) {
      print('File name: ${formData.files.first.value.filename}');
      print('File length: ${formData.files.length}'); // actual size
    }

    // final aliceDioAdapter = AliceDioAdapter();
    // alice.addAdapter(aliceDioAdapter);
    // Dio dio = Dio();
    // dio.options.headers = {
    //   'Authorization': 'Bearer ${CashHelper.to.getData(CacheKeys.token)}',
    //   'Content-Type': 'multipart/form-data',
    // };

    // dio.interceptors.add(aliceDioAdapter);
    // var response = await dio.post(
    //   '${AppEndpoints.baseUrl}api/Clients/UpdateClient',
    //   data: formData,
    // );

    // print('Response status code: ${response.statusCode}');
    // print('Response data: ${response.data}');

    startLoading();
    // var formData = await _buildFormData();
    var res = await profileRepo.updateClient(formData: formData);
    stopLoading();
    res.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        ToastManager.showSuccess('تم التعديل بنجاح');
        // profile.value = r;
        // UserService.to.updateUser(r);
      },
    );
  }

  void loadProfileData() {
    nameController.text = profile.value?.userName ?? '';
    emailController.text = profile.value?.email ?? '';
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  Future<void> deleteAccount(String email) async {
    if (UserService.to.currentUser.value?.userViewModel?.email != email) {
      ToastManager.showError('البريد الإلكتروني غير صحيح');
      return;
    } else {
      startLoading();
      var res = await profileRepo.deleteAccount(email);
      stopLoading();
      // res.fold(
      //   (l) {
      //     ToastManager.showError(l.message);
      //   },
      //   (r) {
      //     ToastManager.showSuccess('تم حذف الحساب بنجاح');
      //     // UserService.to.logout();
      //   },
      // );
    }
  }
}
