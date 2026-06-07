import 'package:dartz/dartz.dart';
import 'package:evex/core/localization/app_strings.dart';
import 'package:evex/core/models/errors/error_message_model.dart';
import 'package:evex/core/models/errors/exceptions.dart';
import 'package:evex/core/services/network_service/api_service.dart';
import 'package:evex/core/services/network_service/endpoints.dart';

import 'package:dio/dio.dart' as d;
import 'package:evex/feature/vendor/add_get_way/data/model/add_port_model/add_port_model_response.dart';
import 'package:evex/feature/vendor/add_get_way/data/model/add_port_model/add_port_request_model/add_port_request_model.dart';
import 'package:get/get.dart';

class AddGetWayRepo {
  static final AddGetWayRepo _instance = AddGetWayRepo._internal();
  AddGetWayRepo._internal();
  factory AddGetWayRepo() {
    return _instance;
  }

  final DioImpl _dioImpl = DioImpl();
  Future<Either<ResponseMessage, AddPortModelResponse>> addPort(
      {required AddPortRequestModel addPortModel, int? id}) async {
    try {
      d.Response response = id == null
          ? (await _dioImpl.post(
              timeOut: 8,
              endPoint: EndPoints.addport,
              data: addPortModel.toJson(),
            ))
          : (await _dioImpl.put(
              timeOut: 8,
              endPoint: '${EndPoints.editPort}/$id',
              data: addPortModel.toJson(),
            ));

      if (response.statusCode == 200) {
        return Right(AddPortModelResponse.fromJson(response.data));
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
