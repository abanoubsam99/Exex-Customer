import 'package:dartz/dartz.dart';
import 'package:evex/core/localization/app_strings.dart';
import 'package:evex/core/models/errors/error_message_model.dart';
import 'package:evex/core/models/errors/exceptions.dart';
import 'package:evex/core/services/network_service/api_service.dart';

import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';

class AddGetWayImageRepo {
  static final AddGetWayImageRepo _instance = AddGetWayImageRepo._internal();
  AddGetWayImageRepo._internal();
  factory AddGetWayImageRepo() {
    return _instance;
  }

  final DioImpl _dioImpl = DioImpl();
  Future<Either<ResponseMessage, String>> addImage(
      {required int id, required List<d.MultipartFile> image}) async {
    try {
      // ignore: unnecessary_null_comparison
      final d.FormData formData = d.FormData.fromMap({
        "images": image,
      });
      d.Response response = await _dioImpl.put(
        endPoint: "api/Ports/AddPortImages/$id",
        data: formData,
      );

      if (response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(ResponseMessage(
            message: response.data['message'].toString(),
            status: response.data['isSuccess']));
      }
    } on PrimaryServerException catch (e) {
      return Left(ResponseMessage(message: e.message, status: false));
    } catch (e) {
      return Left(
          ResponseMessage(message: AppStrings.processFailed.tr, status: false));
    }
  }

  Future<Either<String, List<String>>> getportImageid(int id,
      [isbuffet = false]) async {
    try {
      d.Response response = await DioImpl().get(
        endPoint: "api/Ports/GetPortImages/$id",
      );
      if (response.statusCode == 200) {
        List<String> list = (response.data as List<dynamic>)
            .map((item) => item.toString())
            .toList();

        return Right(list);
      } else {
        return Left(response.data['message']);
      }
    } on PrimaryServerException catch (_) {
      return Left(_.message);
    } catch (e) {
      return const Left('فشل الاتصال');
    }
  }

  Future<Either<ResponseMessage, String>> deleteImage(
      {required int id, required String image}) async {
    try {
      d.Response response = (await _dioImpl
          .put(endPoint: "api/Ports/DeletePortImages/$id", data: [image]));

      if (response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(ResponseMessage(
            message: response.data['message'].toString(),
            status: response.data['isSuccess']));
      }
    } on PrimaryServerException catch (e) {
      return Left(ResponseMessage(message: e.message, status: false));
    } catch (e) {
      return Left(
          ResponseMessage(message: AppStrings.processFailed.tr, status: false));
    }
  }
}
