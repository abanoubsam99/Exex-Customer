import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';

class FavoritesRepo {
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
