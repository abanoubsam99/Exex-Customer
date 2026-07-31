import 'dart:convert';

import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/data/models/user_model.dart';

class UserService {
  final CacheHelper _cacheHelper;
  UserService(this._cacheHelper);

  UserModel? currentUser;

  /// True when a half-finished registration was found on launch (reached the
  /// add-phone / add-client step, then the app was closed) and downgraded to
  /// browse-only. In-memory only — never persisted — and reset the moment the
  /// user actually signs in. See [_loadUser].
  bool _browseOnly = false;

  /// True when the user is browsing without a usable account — either they
  /// chose "تخطّي" on the login screen, or a half-finished registration was
  /// downgraded to browse-only on launch. Cleared automatically once they
  /// actually sign in.
  bool get isGuest =>
      _browseOnly ||
      (currentUser == null &&
          (_cacheHelper.getData(CacheKeys.isGuest) as bool? ?? false));

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
    // A real account replaces any prior guest / browse-only session.
    await _cacheHelper.removeData(key: CacheKeys.isGuest);
    _browseOnly = false;
    currentUser = user;
  }

  Future<void> _loadUser() async {
    final userJson = _cacheHelper.getData(CacheKeys.userModel) as String?;
    if (userJson == null || userJson == 'null') {
      currentUser = null;
      return;
    }
    try {
      final user = UserModel.fromJson(json.decode(userJson));
      // A half-finished registration (reached the add-phone / add-client step,
      // then the app was closed) leaves an incomplete cached user. Don't restore
      // it as an active session: dropping the user onto the home screen would
      // fire auth-only calls (profile / notifications) that 404 with "Not Found"
      // and show a broken "عميل" profile. Instead browse home like a guest; the
      // remaining steps are resumed only if the user logs in again explicitly
      // (LoginCubit routes an incomplete account to add-phone / add-client).
      if (!user.isAccountComplete) {
        currentUser = null;
        _browseOnly = true;
      } else {
        currentUser = user;
      }
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
    _browseOnly = false;
  }
}
