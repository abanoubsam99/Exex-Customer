import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor يطبع cURL كامل + Response + Error
/// بدون تقطيع للنصوص الطويلة.
class CurlLoggerInterceptor extends Interceptor {
  static const int _chunkSize = 800;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    if (kDebugMode) {
      _printLongText(
        '\n╭─────────────── REQUEST ───────────────',
      );

      _printLongText(_buildCurl(options));

      if (options.data != null) {
        _printLongText('\nRequest Body:');
        _printLongText(_prettyBody(options.data));
      }

      _printLongText(
        '╰────────────────────────────────────────\n',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    if (kDebugMode) {
      final opts = response.requestOptions;

      _printLongText(
        '\n╭─────────────── RESPONSE ──────────────',
      );

      _printLongText(
        '✓ [${response.statusCode}] ${opts.method} ${opts.uri}',
      );

      _printLongText('Body:');
      _printLongText(_prettyBody(response.data));

      _printLongText(
        '╰────────────────────────────────────────\n',
      );
    }

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    if (kDebugMode) {
      final opts = err.requestOptions;

      _printLongText(
        '\n╭─────────────── ERROR ─────────────────',
      );

      _printLongText(
        '✗ [${err.response?.statusCode}] ${opts.method} ${opts.uri}',
      );

      _printLongText('\ncURL:');
      _printLongText(_buildCurl(opts));

      _printLongText('\nMessage: ${err.message}');

      if (err.response?.data != null) {
        _printLongText('\nError Body:');
        _printLongText(
          _prettyBody(err.response!.data),
        );
      }

      _printLongText(
        '╰────────────────────────────────────────\n',
      );
    }

    handler.next(err);
  }

  // ─────────────────────────────────────────────

  String _buildCurl(RequestOptions options) {
    final parts = <String>[
      'curl -X ${options.method}',
    ];

    options.headers.forEach((key, value) {
      parts.add("-H '$key: $value'");
    });

    final data = options.data;

    if (data != null) {
      if (data is FormData) {
        for (final field in data.fields) {
          parts.add("-F '${field.key}=${field.value}'");
        }

        for (final file in data.files) {
          parts.add("-F '${file.key}=@${file.value.filename ?? "file"}'");
        }
      } else {
        final body =
        data is String ? data : jsonEncode(data);

        parts.add("-d '$body'");
      }
    }

    parts.add("'${options.uri}'");

    return parts.join(' ');
  }

  String _prettyBody(dynamic data) {
    try {
      if (data is String) {
        return const JsonEncoder.withIndent(
          '  ',
        ).convert(jsonDecode(data));
      }

      return const JsonEncoder.withIndent(
        '  ',
      ).convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  void _printLongText(String text) {
    for (
    int i = 0;
    i < text.length;
    i += _chunkSize
    ) {
      debugPrint(
        text.substring(
          i,
          i + _chunkSize > text.length
              ? text.length
              : i + _chunkSize,
        ),
      );
    }
  }
}