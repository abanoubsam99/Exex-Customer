import 'dart:async';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/reset_password/data/model/forget_password_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repo/add_phone_repo.dart';

class AddPhoneController extends GetxController {
  AddPhoneRepo addPhoneRepo;

  AddPhoneController(this.addPhoneRepo);

  String code = '';
  var phoneController = TextEditingController();
  var countryCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //sendPhone
  addPhone() async {
    startLoading();
    var result = await addPhoneRepo.addPhone(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
    );
    stopLoading();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) async {
        //save userdata in shared pref after update phone

        Get.toNamed(
          Routes.addPhoneOptScreen,
          arguments:
              countryCodeController.text.trim() +
              phoneController.text.substring(1).trim(),
        );
      },
    );
  }
}
