import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordOtpController extends GetxController {
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
