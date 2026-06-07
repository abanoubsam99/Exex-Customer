import 'dart:convert';

import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/data/models/user_model.dart';

class UserService {
  final CacheHelper _cacheHelper;
  UserService(this._cacheHelper);

  UserModel? currentUser;

  Future<void> init() async {
    await _loadUser();
  }

  Future<void> saveUser(UserModel user) async {
    await _cacheHelper.saveData(
      key: CacheKeys.userModel,
      value: json.encode(user.toJson()),
    );
    currentUser = user;
  }

  Future<void> _loadUser() async {
    final userJson = _cacheHelper.getData(CacheKeys.userModel) as String?;
    if (userJson == null || userJson == 'null') {
      currentUser = null;
      return;
    }
    try {
      currentUser = UserModel.fromJson(json.decode(userJson));
    } catch (_) {
      currentUser = null;
    }
  }

  Future<void> updateUser(UserViewModel user) async {
    currentUser!.userViewModel = user;
    await saveUser(currentUser!);
  }

  Future<void> logout() async {
    await _cacheHelper.clearAllData();
    currentUser = null;
  }
}
