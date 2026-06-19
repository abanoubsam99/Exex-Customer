import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/general_response.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';

class FavoritesRepo {
  /// GET /api/Ports/Filter?fav=true — the client's favorite ports. There's no
  /// dedicated GetFavorites endpoint; the backend reuses the ports filter with
  /// `fav=true`, so the response is the standard [PortsRespondModel].
  Future<List<Item>?> getFavorites() async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.ports,
        query: {'fav': true},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return PortsRespondModel.fromJson(response.data).items ?? [];
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
