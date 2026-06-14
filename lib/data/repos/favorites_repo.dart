import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
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

  /// POST /api/Favorites?lessonId={id} — adds an item to favorites.
  Future<bool> addFavorite(int id) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.favorites,
        query: {'lessonId': id},
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// DELETE /api/Favorites/{id} — removes an item from favorites.
  Future<bool> removeFavorite(int id) async {
    try {
      final response = await DioHelper.deleteData(
        url: '${AppEndpoints.favorites}/$id',
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
