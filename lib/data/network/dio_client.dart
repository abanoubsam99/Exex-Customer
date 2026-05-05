// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'token_manager.dart';
//
// class DioClient {
//   final TokenManager _tokenManager;
//   late final Dio _dio;
//
//   // TODO: Replace with the actual API Base URL
//   static const String baseUrl = 'https://api.evex.com/v1';
//
//   DioClient(this._tokenManager) {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
//
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final token = await _tokenManager.getToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//
//         // Add single language rule: ar
//         options.headers['Accept-Language'] = 'ar';
//
//         if (kDebugMode) {
//           print('REQUEST[${options.method}] => PATH: ${options.path}');
//         }
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         if (kDebugMode) {
//           print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
//         }
//         return handler.next(response);
//       },
//       onError: (DioException e, handler) async {
//         if (kDebugMode) {
//           print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
//         }
//         if (e.response?.statusCode == 401) {
//           // Handle unauthorized exception globally
//           // E.g. clear token and redirect to login
//           await _tokenManager.clearToken();
//           // We'll manage navigation to login from the bloc/cubit layer or global navigator key
//         }
//         return handler.next(e);
//       },
//     ));
//   }
//
//   Dio get dio => _dio;
// }
