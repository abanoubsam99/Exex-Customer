import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';

import 'cache_helper.dart';
import 'curl_logger_interceptor.dart';

// Alice يستخدم نفس الـ navigatorKey بتاع التطبيق، والإشعار مقفول
// عشان ميعملش crash (AliceCore._onCallsChanged null check).
//
// The shake gesture is enabled only in debug builds — both shake-to-open and
// the notification default to `true` in AliceConfiguration, which would pop the
// HTTP inspector in front of end users (e.g. an accidental phone shake while
// switching apps). In release we keep Alice wired as a dio adapter but with no
// way to surface its UI.
final Alice alice = Alice(
  configuration: AliceConfiguration(
    navigatorKey: NavigationHelper.navigatorKey,
    showNotification: false,
    showInspectorOnShake: kDebugMode,
  ),
);

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

    // 1) إضافة التوكن تلقائياً + عرض رسالة الخطأ من السيرفر
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _cacheHelper.getData(CacheKeys.token) as String?;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final message = extractServerMessage(error);
          if (message != null && message.isNotEmpty) {
            ToastManager.showError(message);
          }
          handler.next(error);
        },
      ),
    );

    // 2) طباعة cURL + Response/Error في الـ terminal (debug فقط)
    _dio.interceptors.add(CurlLoggerInterceptor());

    // 3) Alice (HTTP inspector)
    final aliceAdapter = AliceDioAdapter();
    alice.addAdapter(aliceAdapter);
    _dio.interceptors.add(aliceAdapter);
  }

  /// بيستخرج رسالة الخطأ من رد السيرفر، بيغطي كذا احتمال للشكل اللي بيرجع به الباك:
  ///   1) {"message": "..."} أو {"Message": "..."} أو {"error": "..."}
  ///   2) ASP.NET validation: {"errors": {"Name": ["..."], "City": ["..."]}}
  ///   3) {"errors": ["...", "..."]} أو {"errors": "..."}
  ///   4) {"title": "..."} (fallback)
  ///   5) الرد نفسه String
  /// وبيرجّع رسالة مناسبة لأخطاء الاتصال/التايم آوت.
  static String? extractServerMessage(DioException error) {
    final data = error.response?.data;

    if (data is String && data.trim().isNotEmpty) return data.trim();

    if (data is Map) {
      // 1) رسالة مباشرة
      final direct = data['message'] ?? data['Message'] ?? data['error'];
      if (direct is String && direct.isNotEmpty) return direct;

      // 2 + 3) حقل errors بأشكاله المختلفة
      final errors = data['errors'] ?? data['Errors'];
      final fromErrors = _messageFromErrors(errors);
      if (fromErrors != null) return fromErrors;

      // 4) العنوان كحل أخير
      final title = data['title'] ?? data['Title'];
      if (title is String && title.isNotEmpty) return title;
    }

    // 5) أخطاء الاتصال / التايم آوت
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال، حاول مرة أخرى';
      case DioExceptionType.connectionError:
        return 'تعذّر الاتصال بالخادم، تأكد من الإنترنت';
      default:
        break;
    }

    // Fallback for responses with no readable message (e.g. 404/500 with an
    // empty or unexpected body): surface the status code + a snippet of the
    // raw body so the problem is visible to the user.
    final statusCode = error.response?.statusCode;
    if (statusCode != null) return _messageForStatus(statusCode, data);

    return 'حدث خطأ غير متوقع، حاول مرة أخرى';
  }

  /// A friendly Arabic message for an HTTP status code, with the code and a
  /// short snippet of the raw body appended when present.
  static String _messageForStatus(int code, dynamic data) {
    String base;
    if (code == 400) {
      base = 'طلب غير صحيح';
    } else if (code == 401) {
      base = 'انتهت الجلسة، سجّل الدخول مرة أخرى';
    } else if (code == 403) {
      base = 'غير مسموح بهذا الإجراء';
    } else if (code == 404) {
      base = 'الخدمة غير متاحة';
    } else if (code == 408) {
      base = 'انتهت مهلة الطلب';
    } else if (code == 422) {
      base = 'بيانات غير صالحة';
    } else if (code >= 500) {
      base = 'مشكلة في السيرفر';
    } else {
      base = 'حدث خطأ';
    }
    final snippet = _shortBody(data);
    return snippet == null ? '$base ($code)' : '$base ($code): $snippet';
  }

  /// A trimmed, length-capped string view of the raw response body.
  static String? _shortBody(dynamic data) {
    if (data == null) return null;
    final s = data.toString().trim();
    if (s.isEmpty || s == '{}' || s == '[]') return null;
    return s.length > 200 ? '${s.substring(0, 200)}…' : s;
  }

  /// بيجمع رسائل الـ validation من حقل errors مهما كان شكله.
  static String? _messageFromErrors(dynamic errors) {
    if (errors == null) return null;

    // Map<field, List<msg>> (شكل ASP.NET) أو Map<field, String>
    if (errors is Map) {
      final messages = <String>[];
      for (final value in errors.values) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value != null) {
          messages.add(value.toString());
        }
      }
      if (messages.isNotEmpty) return messages.join('\n');
    }

    // List<msg>
    if (errors is List && errors.isNotEmpty) {
      return errors.map((e) => e.toString()).join('\n');
    }

    // String
    if (errors is String && errors.isNotEmpty) return errors;

    return null;
  }

  // ── Static network helpers used directly by repositories ──
  // The auth token is injected automatically by the request interceptor.
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.get(url, queryParameters: query, options: options);
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.post(url, data: data, queryParameters: query, options: options);
  }

  static Future<Response> putData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.put(url, data: data, queryParameters: query, options: options);
  }

  static Future<Response> deleteData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.delete(
      url,
      data: data,
      queryParameters: query,
      options: options,
    );
  }
}
