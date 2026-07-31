import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs every request / response / error to the Dart console in debug
/// builds. No-ops in release so the production binary never emits
/// verbose network logs.
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '→ ${options.method} ${options.uri}',
        name: 'DioLogger',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}',
        name: 'DioLogger',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '✗ ${err.requestOptions.method} ${err.requestOptions.uri} '
        '→ ${err.type.name} ${err.message ?? ''}',
        name: 'DioLogger',
        error: err,
      );
    }
    handler.next(err);
  }
}
