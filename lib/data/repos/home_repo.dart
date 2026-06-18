import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/special_offer.dart';

class HomeRepo {
  Future<List<PortCategoryWithPortTypes>?> getHomeUserAppInfo({
    String? gov,
    String? city,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.getHomeUserAppInfo,
        query: {'gov': gov, 'city': city},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => PortCategoryWithPortTypes.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Services/GetAllServicesByClient — the featured "special offers".
  /// On home it's called without [portTypeId]; the instant-booking and direct-
  /// services lists pass the selected port type to filter the offers.
  Future<List<SpecialOffer>?> getSpecialOffers({
    int? portTypeId,
    String? gov,
    String? city,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.getAllServicesByClient,
        query: {
          'specialOffer': true,
          if (portTypeId != null) 'portTypeId': portTypeId,
          'gov': gov,
          'city': city,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => SpecialOffer.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
