import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/add_client_response.dart';

class AddClientRepo {
  Future<AddClientResponse?> addClient({
    required String name,
    required String governorate,
    required String city,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.addClient,
        data: FormData.fromMap({
          'name': name,
          'governorate': governorate,
          'city': city,
        }),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return AddClientResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
