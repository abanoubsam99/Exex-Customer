import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/services/user_service.dart';

class NewSuggestionRepo {
  final UserService _userService;
  NewSuggestionRepo(this._userService);

  /// إرسال اقتراح بتاجر/مقدم خدمة جديد. بيرجّع `true` لو نجح.
  ///
  /// الـ body بيتبع contract الـ backend: POST /api/Suggestions
  Future<bool> submitSuggestion({
    required String vendorName,
    required int serviceType,
    required String vendorGovernorate,
    required String vendorCity,
    required String phoneNumber,
    required String address,
    String link = '',
    required String occasionType,
    required String occasionGovernorate,
    String? occasionDate,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.newSuggestion,
        data: {
          'id': 0,
          'vendorName': vendorName,
          'vendorGovernorate': vendorGovernorate,
          'vendorCity': vendorCity,
          'serviceType': serviceType,
          'occasionGovernorate': occasionGovernorate,
          'phoneNumber': phoneNumber,
          'link': link,
          'address': address,
          'occasionType': occasionType,
          'occasionDate': _toIso(occasionDate),
          'dateAdded': DateTime.now().toUtc().toIso8601String(),
          'userId': _userService.currentUser?.userViewModel?.userId ?? '',
        },
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// بيحوّل تاريخ المناسبة (يجي بصيغة yyyy-MM-dd من الـ date picker) لـ ISO 8601.
  /// لو فاضي أو غير صالح بيرجّع التاريخ الحالي.
  String _toIso(String? date) {
    if (date == null || date.trim().isEmpty) {
      return DateTime.now().toUtc().toIso8601String();
    }
    try {
      return DateTime.parse(date.trim()).toUtc().toIso8601String();
    } catch (_) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }
}
