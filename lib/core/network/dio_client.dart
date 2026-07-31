import 'package:dio/dio.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Thin wrapper around `Dio` with the project's standard interceptor
/// pipeline attached.
///
/// Phase 35 contract (see `docs/backendconnection/backend.mermaid` —
/// Phase 35 Network Plumbing):
///
/// * 10-second connect / 15-second receive / 15-second send timeouts.
/// * `Accept: application/json` and `Content-Type: application/json`
///   by default.
/// * `validateStatus` accepts every 2xx–4xx so error mapping can be
///   centralised in `ErrorHandler` rather than thrown by Dio.
/// * Interceptors, in order:
///   1. `LoggerInterceptor` — debug-only request/response/error log.
///   2. `RetryInterceptor` — idempotent methods only (GET / HEAD),
///      exponential backoff (`baseDelay * 2^attempt + jitter`), three
///      attempts, honours `CancelToken`.
///   3. `AuthInterceptor` — opt-in `Bearer <idToken>` via the
///      `X-Require-Auth` header. Quiz Hub is public so callers leave
///      the flag off; Cloud Functions endpoints set it explicitly.
///
/// Phase 51 — `secure: true` switches the pipeline:
///   * `AuthInterceptor` is inserted BEFORE the retry interceptor so
///     401 / 403 surface without retry storms.
///   * `X-Require-Auth: true` is added to every request by default.
///   * `SecureDioClient.build` adds the Riverpod-aware
///     `AuthInterceptor.withRef` so `X-Require-Role` works.
class DioClient {
  DioClient._(this.dio);

  /// Underlying `Dio` instance. Exposed so feature code can issue
  /// requests directly when the high-level helpers don't cover a
  /// niche call shape.
  final Dio dio;

  /// Builds a [DioClient] bound to [baseUrl] with the project's
  /// standard interceptor pipeline attached.
  ///
  /// Set [secure] to `true` to opt into the authenticated pipeline
  /// (used by Cloud Function callers — see [SecureDioClient]).
  factory DioClient.build({
    required String baseUrl,
    Iterable<Interceptor> extraInterceptors = const <Interceptor>[],
    Map<String, String>? defaultHeaders,
    bool secure = false,
    AuthInterceptor? authInterceptor,
  }) {
    final Map<String, String> baseHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (secure) 'X-Require-Auth': 'true',
      ...?defaultHeaders,
    };
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: baseHeaders,
        responseType: ResponseType.json,
        followRedirects: true,
        validateStatus: (int? status) =>
            status != null && status >= 200 && status < 500,
      ),
    );

    final AuthInterceptor auth = authInterceptor ?? AuthInterceptor();
    final List<Interceptor> pipeline = <Interceptor>[
      LoggerInterceptor(),
      if (secure) auth,
      RetryInterceptor(),
      if (!secure) auth,
      ...extraInterceptors,
    ];
    for (final Interceptor i in pipeline) {
      dio.interceptors.add(i);
    }
    return DioClient._(dio);
  }
}