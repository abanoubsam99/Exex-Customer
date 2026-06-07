import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:flutter/foundation.dart';

import 'cache_helper.dart';

final Alice alice = Alice();
// final Alice alice = Alice(showNotification: true);

class DioHelper {
  static late final Dio _dio;
  static late final CacheHelper _cacheHelper;

  static Dio get dio => _dio;

  static void init(CacheHelper cacheHelper) {
    _cacheHelper = cacheHelper;
    const timeout = Duration(seconds: 30);
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _cacheHelper.getData(CacheKeys.token) as String?;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('→ [${options.method}] ${options.uri}');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('✗ Dio error: ${error.message}');
          }
          handler.next(error);
        },
      ),
    );

    // Alice (HTTP inspector)
    final aliceAdapter = AliceDioAdapter();
    alice.addAdapter(aliceAdapter);
    _dio.interceptors.add(aliceAdapter);
  }
}
