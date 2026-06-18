import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/general_response.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';

class FavoritesRepo {
  /// GET /api/Favorites — the client's favorite ports.
  /// Parsing is defensive (handles a raw list or a paged `{ items: [...] }`)
  /// until the exact response shape is confirmed.
  Future<List<Item>?> getFavorites() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.favorites);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final list = data is List
            ? data
            : (data is Map ? (data['items'] ?? data['favorites']) : null);
        if (list is List) {
          return list.map((e) => Item.fromJson(e)).toList();
        }
        return [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Favorites?portId={id} — adds a port to favorites.
  /// Returns the server response (with its message) on success, null on failure.
  Future<GeneralResponse?> addFavorite(int id) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.favorites,
        query: {'portId': id},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GeneralResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// DELETE /api/Favorites/{id} — removes a port from favorites.
  /// Returns the server response (with its message) on success, null on failure.
  Future<GeneralResponse?> removeFavorite(int id) async {
    try {
      final response = await DioHelper.deleteData(
        url: '${AppEndpoints.favorites}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GeneralResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
