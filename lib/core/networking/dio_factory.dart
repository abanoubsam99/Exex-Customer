import 'package:alice/alice.dart';
import 'package:alice/core/alice_adapter.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:evex_user/core/constants/alice.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/helpers/cash_helper.dart';
import 'package:evex_user/core/services/token_service.dart';
import 'package:flutter/material.dart';

import '../di/dependency_injection.dart';

// import '../helpers/shared_pref_helper.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static late Dio _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    _dio =
        Dio(
            BaseOptions(
              contentType: 'Application/json',
              baseUrl: AppEndpoints.baseUrl,
              connectTimeout: timeOut,
              receiveTimeout: timeOut,
            ),
          )
          ..options.connectTimeout = timeOut
          ..options.receiveTimeout = timeOut;
    // addDioHeaders();
    addDioInterceptor();

    return _dio;
  }

  // static void addDioHeaders() async {
  //   _dio.options.headers = {
  //     'Accept': 'application/json',
  //   };
  // }

  static void addDioInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await CashHelper.to.getData(CacheKeys.token);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    // Alice interceptor
    final aliceDioAdapter = AliceDioAdapter();
    alice.addAdapter(aliceDioAdapter);
    _dio.interceptors.add(aliceDioAdapter);
  }
}
