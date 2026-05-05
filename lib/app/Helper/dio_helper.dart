import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/ApiName.dart';
import 'CacheHelper.dart';
class DioHelper {
  static  Dio _dio = Dio();
  static init() {
    _dio = Dio(BaseOptions(
        baseUrl: ApiName.baseUrl,
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) =>true,
        headers: {
          "Content-Type":"application/json",
          "Authorization": "Bearer ${CacheHelper.getToken()}"
        }
    ));
  }
  static Future<Response> getData(
      {required String url, Options? options,dynamic data}) async =>
      await _dio.get(url, options: options,queryParameters: data,);

  static Future<Response> postData(
      {required String url,
        required dynamic data,
        void Function(int, int)? onSendProgress,
        Options? options}) async {
    print("url=> $url");
    print("data=> $data");
    return _dio.post(url, data: data, options: options, onSendProgress: onSendProgress);
  }



  static Future<Response> putData(
      {required String url,
        required dynamic data,
        Options? options}) async =>
      await _dio.put(url, data: data, options: options);

  static Future<Response> deleteData(
      {required String url, dynamic data, Options? options}) async =>
      await _dio.delete(url, data: data, options: options);

  static String handleResponseFailures(
      {required Response? response, String? msg}) {
    switch (response?.statusCode) {
      case 400:
        return msg ?? 'BadRequestFailure';
      case 401:
        return msg ?? 'UnauthorizedFailure';
      case 403:
        return msg ?? 'ForbiddenFailure';
      case 404:
        return msg ?? 'NotFoundFailure';
      case 409:
        return msg ?? 'ConflictFailure';
      case 500:
        return msg ?? 'InternalServerErrorFailure';
      case 503:
        return msg ?? 'ServiceUnavailableFailure';
      default:
        return msg ?? 'UnKnownFailure';
    }
  }

  static String handlingDioFailures(
      {required DioErrorType dioErrorType,
        required Response? response,
        String? msg}) {
    switch (dioErrorType) {
      case DioErrorType.connectionTimeout:
        return 'ConnectTimeoutFailure';
      case DioErrorType.sendTimeout:
        return 'SendTimeoutFailure';
      case DioErrorType.receiveTimeout:
        return 'ReceiveTimeoutFailure';
      case DioErrorType.badResponse:
        return handleResponseFailures(response: response, msg: msg);
      case DioErrorType.cancel:
        return 'CancelRequestFailure';
    // case DioErrorType.othe:
    //   return 'UnKnownFailure';
      default:
        return 'UnKnownFailure';
    }
  }

  static void log(data) {
    if (kDebugMode) print(data.toString());
  }
}
