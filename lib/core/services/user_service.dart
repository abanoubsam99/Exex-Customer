import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/helpers/cash_helper.dart';
import 'package:evex_user/core/models/user_model.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  final currentUser = Rxn<UserModel>();
  final isAcceptedAsVendor = false.obs;

  Future<UserService> init() async {
    await _loadUser();
    return this;
  }

  void setAcceptedAsVendor(bool value) {
    isAcceptedAsVendor.value = value;
  }

  Future<void> saveUser(UserModel user) async {
    await CashHelper.to.saveData(key: CacheKeys.userModel, value: json.encode(user.toJson()));
    currentUser.value = user;
  }

  Future<void> _loadUser() async {
    final userJson = await CashHelper.to.getData(CacheKeys.userModel);
    
    if (userJson == null || userJson == "null") {
      currentUser.value = null;
      return;
    }

    try {
      currentUser.value = UserModel.fromJson(json.decode(userJson));
    } catch (e) {
      currentUser.value = null;
    }
  }

  updateUser(UserViewModel user) async {
    currentUser.value!.userViewModel = user;
    await saveUser(currentUser.value!);
  }

  Future<bool> logout() async {
    Get.deleteAll(force: true);
    await CashHelper.to.clearAllData();
    currentUser.value = null;
    isAcceptedAsVendor.value = false;
    await Get.putAsync(() => UserService().init());
    return true;
  }
}