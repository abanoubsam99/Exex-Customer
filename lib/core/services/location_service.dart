import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';

/// Persists the location the user picks on onboarding (governorate + city) and
/// exposes it to the data APIs that filter by `gov`/`city`. Constructor-injected
/// like [UserService] — single source of truth for the saved location.
class LocationService {
  final CacheHelper _cacheHelper;
  LocationService(this._cacheHelper);

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
  String? get govName =>
      _cacheHelper.getData(CacheKeys.selectedGovName) as String?;
  int? get cityId => _cacheHelper.getData(CacheKeys.selectedCityId) as int?;
  String? get cityName =>
      _cacheHelper.getData(CacheKeys.selectedCityName) as String?;

  /// True once the user has picked both a governorate and a city.
  bool get hasLocation =>
      (govName?.isNotEmpty ?? false) && (cityName?.isNotEmpty ?? false);
}
