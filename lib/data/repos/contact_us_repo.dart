import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/branch.dart';
import 'package:evex_user/data/models/contact_info.dart';

class ContactUsRepo {
  /// GET /api/Home/GetEVEXContactInfoAndSocialMedia
  Future<ContactInfo?> getContactInfo() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.contactInfo);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ContactInfo.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Home/GetAllBranchs?index=0&size=20 — returns the branch items.
  Future<List<Branch>?> getBranches({int index = 0, int size = 20}) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.branches,
        query: {'index': index, 'size': size},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final items = response.data['items'] as List?;
        return items?.map((e) => Branch.fromJson(e)).toList() ?? [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
