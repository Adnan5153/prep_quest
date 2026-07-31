import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_client.dart';
import 'interceptors/auth_interceptor.dart';

/// Authenticated Dio client for Cloud Functions endpoints.
///
/// Phase 51 — wraps [DioClient.build] with `secure: true` and wires
/// [AuthInterceptor.withRef] so the role-based `X-Require-Role` header
/// works against the active user loaded in the Riverpod container.
/// The default header set is `{X-Require-Auth: true,
/// X-Require-Role: authenticated}`; callers may override per request.
class SecureDioClient {
  SecureDioClient._(this.dio);

  final Dio dio;

  factory SecureDioClient.build({
    required String baseUrl,
    required Ref ref,
    Iterable<Interceptor> extraInterceptors = const <Interceptor>[],
  }) {
    return SecureDioClient._(
      DioClient.build(
        baseUrl: baseUrl,
        secure: true,
        authInterceptor: AuthInterceptor.withRef(ref),
        defaultHeaders: const <String, String>{
          'X-Require-Auth': 'true',
          'X-Require-Role': 'authenticated',
        },
        extraInterceptors: extraInterceptors,
      ).dio,
    );
  }
}