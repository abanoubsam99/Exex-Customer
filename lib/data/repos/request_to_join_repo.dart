import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';

class RequestToJoinRepo {
  /// Submits a request to join the evex vendor network.
  /// POST /api/VendorRequests (JSON body). Returns `true` on success.
  Future<bool> submitJoinRequest({
    required String name,
    required String serviceType,
    required String governorate,
    required String city,
    required String address,
    required String countryCode,
    required String phone,
    required String email,
    String gps = '',
    String pageLink = '',
    String additionalLink = '',
    String otherInfo = '',
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.vendorRequests,
        data: {
          'name': name,
          'email': email,
          'governorate': governorate,
          'city': city,
          'gps': gps,
          'phoneNumber': '$countryCode$phone',
          'address': address,
          'serviceType': serviceType,
          'link': pageLink,
          'additionalLink': additionalLink,
          'additionalInfo': otherInfo,
        },
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
