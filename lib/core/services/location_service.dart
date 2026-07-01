import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/services/user_service.dart';

/// Persists the location the user picks on onboarding (governorate + city) and
/// exposes it to the data APIs that filter by `gov`/`city`. Constructor-injected
/// like [UserService] — single source of truth for the location used to filter.
///
/// For a signed-in user the profile governorate/city take precedence over the
/// onboarding pick, so changing the location in the profile immediately
/// re-filters the home, offers and lists. Guests (no profile) fall back to the
/// onboarding pick.
class LocationService {
  final CacheHelper _cacheHelper;
  final UserService _userService;
  LocationService(this._cacheHelper, this._userService);

  Future<void> save({
    required int govId,
    required String govName,
    required int cityId,
    required String cityName,
  }) async {
    await _cacheHelper.saveData(key: CacheKeys.selectedGovId, value: govId);
    await _cacheHelper.saveData(key: CacheKeys.selectedGovName, value: govName);
    await _cacheHelper.saveData(key: CacheKeys.selectedCityId, value: cityId);
    await _cacheHelper.saveData(
        key: CacheKeys.selectedCityName, value: cityName);
  }

  int? get govId => _cacheHelper.getData(CacheKeys.selectedGovId) as int?;
  int? get cityId => _cacheHelper.getData(CacheKeys.selectedCityId) as int?;

  /// The onboarding-saved names (raw, ignoring the profile).
  String? get _savedGovName =>
      _cacheHelper.getData(CacheKeys.selectedGovName) as String?;
  String? get _savedCityName =>
      _cacheHelper.getData(CacheKeys.selectedCityName) as String?;

  /// Governorate used for `gov` filtering: the signed-in user's profile
  /// governorate when set, otherwise the onboarding pick.
  String? get govName => _firstNonEmpty(
      [_userService.currentUser?.userViewModel?.governorate, _savedGovName]);

  /// City used for `city` filtering: the signed-in user's profile city when
  /// set, otherwise the onboarding pick.
  String? get cityName => _firstNonEmpty(
      [_userService.currentUser?.userViewModel?.city, _savedCityName]);

  /// True once the user has picked both a governorate and a city.
  bool get hasLocation =>
      (govName?.isNotEmpty ?? false) && (cityName?.isNotEmpty ?? false);

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }
}
