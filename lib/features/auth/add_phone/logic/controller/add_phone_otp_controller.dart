import 'dart:async';
import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/add_phone/data/repo/add_phone_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/routing/routes.dart';

class AddPhoneOtpController extends GetxController {
  AddPhoneRepo addPhoneRepo;

  AddPhoneOtpController(this.addPhoneRepo);

  TextEditingController codeController = TextEditingController();
  Timer? timer;
  RxInt seconds = 60.obs;
  RxString phone = ''.obs;
  Future<void> resendCode() async {
    seconds.value = 60;
    // await resendCodeToUser();
    beginTimer();
  }

  RxBool isValid = false.obs;
  beginTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  confirmCode() async {
    startLoading();
    var result = await addPhoneRepo.confirmPhone(
      code: codeController.text.trim(),
    );
    stopLoading();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) async {
        //save userdata in shared pref after update phone
        UserModel user = UserService.to.currentUser.value!;
        user.userViewModel!.phoneNumber = phone.value.trim();
        UserService.to.saveUser(user);
        Get.offAllNamed(Routes.addClientScreen);
      },
    );
  }

  //Todo: later
  Future<void> resendCodeToUser() async {
    // startLoading();
    // var result = await _verfiryAccountRepo.resendCode();
    // stopLoading();
    // result.fold(
    //   (l) {
    //     ToastManager.showSuccess(l.message, false);
    //   },
    //   (r) async {
    //     ToastManager.showSuccess(r, true);
    //   },
    // );
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      phone.value = Get.arguments;
    }
    await beginTimer();
    super.onInit();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
