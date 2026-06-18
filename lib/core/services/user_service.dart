import 'dart:convert';

import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/data/models/user_model.dart';

class UserService {
  final CacheHelper _cacheHelper;
  UserService(this._cacheHelper);

  UserModel? currentUser;

  /// True when the user chose "تخطّي" on the login screen and is browsing
  /// without an account. Cleared automatically once they actually sign in.
  bool get isGuest =>
      currentUser == null &&
      (_cacheHelper.getData(CacheKeys.isGuest) as bool? ?? false);

  Future<void> init() async {
    await _loadUser();
  }

  /// Enters guest (browse-only) mode.
  Future<void> continueAsGuest() async {
    await _cacheHelper.saveData(key: CacheKeys.isGuest, value: true);
  }

  Future<void> saveUser(UserModel user) async {
    await _cacheHelper.saveData(
      key: CacheKeys.userModel,
      value: json.encode(user.toJson()),
    );
    // A real account replaces any prior guest session.
    await _cacheHelper.removeData(key: CacheKeys.isGuest);
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
    // Preserve device-level flags (first-install onboarding) across logout so
    // the onboarding / location step only ever appears on first install.
    final onboardingDone = _cacheHelper.getData('onboardingCompleted');
    await _cacheHelper.clearAllData();
    if (onboardingDone == true) {
      await _cacheHelper.saveData(key: 'onboardingCompleted', value: true);
    }
    currentUser = null;
  }
}
