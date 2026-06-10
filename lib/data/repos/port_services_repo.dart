import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/review.dart';
import 'package:evex_user/data/models/service_details_model.dart';

class PortServicesRepo {
  Future<List<PortService>?> getAllPortServices(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.services,
        query: {'portId': portId},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => PortService.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<AdditionModel>?> getAdditions(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.addition,
        query: {'portId': portId},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => AdditionModel.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reviews/{portId}?index=0&size=20 — returns the review items.
  Future<List<Review>?> getReviews(int portId,
      {int index = 0, int size = 20}) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.reviews}/$portId',
        query: {'index': index, 'size': size},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final items = response.data['items'] as List?;
        return items?.map((e) => Review.fromJson(e)).toList() ?? [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<ServiceDetailsModel?> getServiceData(int id) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.serviceData}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ServiceDetailsModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
