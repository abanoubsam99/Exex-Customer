import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor يطبع أمر cURL كامل لكل request + الـ response/error في الـ terminal.
/// شغّال في debug mode بس.
class CurlLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n╭─────────────── REQUEST ───────────────');
      debugPrint(_buildCurl(options));
      debugPrint('╰────────────────────────────────────────\n');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final opts = response.requestOptions;
      debugPrint('\n╭─────────────── RESPONSE ──────────────');
      debugPrint('✓ [${response.statusCode}] ${opts.method} ${opts.uri}');
      debugPrint('Body: ${_prettyBody(response.data)}');
      debugPrint('╰────────────────────────────────────────\n');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final opts = err.requestOptions;
      debugPrint('\n╭─────────────── ERROR ─────────────────');
      debugPrint('✗ [${err.response?.statusCode}] ${opts.method} ${opts.uri}');
      debugPrint('cURL: ${_buildCurl(opts)}');
      debugPrint('Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Body: ${_prettyBody(err.response?.data)}');
      }
      debugPrint('╰────────────────────────────────────────\n');
    }
    handler.next(err);
  }

  // ── Helpers ──────────────────────────────────────────────

  String _buildCurl(RequestOptions options) {
    final parts = <String>['curl -X ${options.method}'];

    // Headers
    options.headers.forEach((key, value) {
      parts.add("-H '$key: $value'");
    });

    // Body
    final data = options.data;
    if (data != null) {
      if (data is FormData) {
        final fields =
            data.fields.map((e) => '${e.key}=${e.value}').join('&');
        final files = data.files.map((e) => '${e.key}=@file').join('&');
        final combined = [fields, files].where((e) => e.isNotEmpty).join('&');
        parts.add("-F '$combined'");
      } else {
        final body = data is String ? data : jsonEncode(data);
        parts.add("-d '$body'");
      }
    }

    // URL (مع الـ query params)
    parts.add("'${options.uri}'");

    return parts.join(' ');
  }

  String _prettyBody(dynamic data) {
    try {
      if (data is String) {
        return const JsonEncoder.withIndent('  ')
            .convert(jsonDecode(data));
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
