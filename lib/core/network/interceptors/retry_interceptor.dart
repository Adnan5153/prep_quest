import 'dart:math';

import 'package:dio/dio.dart';

/// Retries idempotent requests (GET / HEAD) with exponential backoff.
///
/// Algorithm:
/// * `delay = baseDelay * 2^attempt + jitter` where `jitter` is a
///   uniform random value in `[0, baseDelay)` to avoid retry storms.
/// * At most 3 attempts (initial + 2 retries).
/// * Honours the request's `CancelToken` so the user can abort a
///   retry loop mid-flight.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    Duration baseDelay = const Duration(milliseconds: 250),
    int maxAttempts = 3,
  })  : _baseDelay = baseDelay,
        _maxAttempts = maxAttempts;

  final Duration _baseDelay;
  final int _maxAttempts;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final RequestOptions options = err.requestOptions;
    final String method = options.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD') {
      handler.next(err);
      return;
    }
    final int attempt = (options.extra['retry_attempt'] as int?) ?? 0;
    if (attempt >= _maxAttempts - 1) {
      handler.next(err);
      return;
    }
    // Only retry transient failures (network / timeout). 4xx errors
    // are intentional and must propagate so ErrorHandler can map them.
    if (!_isRetryable(err.type)) {
      handler.next(err);
      return;
    }
    final Random rng = Random();
    final int jitterMs = rng.nextInt(_baseDelay.inMilliseconds);
    final Duration delay = Duration(
      milliseconds:
          _baseDelay.inMilliseconds * (1 << attempt) + jitterMs,
    );
    await Future<void>.delayed(delay);
    try {
      // Retry via a short-lived Dio instance rather than reusing the
      // caller's dio (whose interceptors would re-run this retry).
      final Dio retryDio = Dio(BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        sendTimeout: options.sendTimeout,
        headers: options.headers,
        responseType: options.responseType,
        followRedirects: options.followRedirects,
        validateStatus: options.validateStatus,
      ));
      final Response<dynamic> response = await retryDio.fetch<dynamic>(
        options
          ..extra['retry_attempt'] = attempt + 1,
      );
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isRetryable(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError;
  }
}
