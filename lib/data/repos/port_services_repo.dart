import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/review.dart';
import 'package:evex_user/data/models/service_details_model.dart';

class PortServicesRepo {
  /// GET /api/Services/GetAllServicesByClient?portId={portId}&specialOffer=false&portTypeId=0
  /// Loads the services of a specific port. [portId] identifies the port itself,
  /// not its type — [portTypeId] (0 = no filter) filters by type, and
  /// [specialOffer] limits the result to special offers.
  Future<List<PortService>?> getAllPortServices(
    int portId, {
    bool specialOffer = false,
    int portTypeId = 0,
    int? occasionId,
  }) async {
    try {
      final query = <String, dynamic>{
        'portId': portId,
        'specialOffer': specialOffer,
        'portTypeId': portTypeId,
      };
      if (occasionId != null && occasionId > 0) {
        query['occasionId'] = occasionId;
      }
      final response = await DioHelper.getData(
        url: AppEndpoints.getAllServicesByClient,
        query: query,
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

  /// GET /api/Reviews/?id={portId}&index=0&size=20 — returns the review items.
  Future<List<Review>?> getReviews(int portId,
      {int index = 0, int size = 20}) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.reviews,
        query: {'id': portId, 'index': index, 'size': size},
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

  /// GET /api/Ports/GetPortImages/{portId} — the port's gallery image paths
  /// (relative paths under Uploads/...). Returns null on failure.
  Future<List<String>?> getPortImages(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.getPortImages}/$portId',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();
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

  Future<List<String>?> getPortContactInfo(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.getPortContactInfo}/$portId',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final d = response.data;
        return [
          if (d['phoneNumber1'] != null) d['phoneNumber1'].toString(),
          if (d['phoneNumber2'] != null) d['phoneNumber2'].toString(),
        ].where((e) => e.trim().isNotEmpty).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
