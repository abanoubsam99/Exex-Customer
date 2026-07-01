import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';

class LocationRepo {
  Future<List<Governate>?> getGovernorates() async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.governorates,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => Governate.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<City>?> getCities(int govId) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.cities.replaceAll('{govId}', '$govId'),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List).map((e) => City.fromJson(e)).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/GetPortGovernorates/{portId} — the governorate names
  /// the port serves. Returns null on failure so the caller can decide whether
  /// to fall back to the full list.
  Future<List<String>?> getPortGovernorates(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.getPortGovernorates}/$portId',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/GetPortCitiesByGov/{portId} — the city names the port
  /// serves within its working area (across its governorates).
  Future<List<String>?> getPortCities(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.getPortCitiesByGov}/$portId',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
