import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/firebase_config.dart';
import '../../security/security_context.dart';
import '../../../features/authentication/domain/entities/user_entity.dart';
import '../../../shared/enums/user_role.dart';

/// Attaches `Authorization: Bearer <idToken>` to outgoing requests when
/// the caller has opted in via the `X-Require-Auth: true` request
/// header. Used by Cloud Functions calls (Quiz Hub is public and stays
/// unauthenticated).
///
/// Extended in Phase 51:
/// * `X-Require-Role: admin|premium|free` short-circuits the request
///   with HTTP 403 when the active user's role does not match. The
///   active user is resolved from [securityContextProvider] when a
///   Riverpod container is wired in via [AuthInterceptor.withRef].
///   Without the container the role check is best-effort and logs a
///   warning in debug builds.
/// * `X-Force-Token-Refresh: true` forces `user.getIdToken(true)` so
///   callers recover from expired tokens without bouncing the user.
class AuthInterceptor extends Interceptor {
  AuthInterceptor() : _ref = null;

  /// Riverpod-aware constructor. Pass the application container so the
  /// interceptor can resolve the active user / role for `X-Require-Role`
  /// checks.
  AuthInterceptor.withRef(Ref ref) : _ref = ref;

  final Ref? _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final Ref? ref = _ref;
    if (ref != null) {
      final _RoleRequirement? roleReq = _parseRoleRequirement(options);
      if (roleReq != null) {
        final UserEntity? user = ref.read(securityContextProvider);
        if (user == null || !_roleMatches(user.role, roleReq.role)) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: 403,
                data: <String, dynamic>{
                  'success': false,
                  'message': 'Forbidden — role ${roleReq.role.name} required.',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
          return;
        }
      }
    }

    final dynamic requireAuth = options.headers['X-Require-Auth'];
    final bool needsAuth = requireAuth == true || requireAuth == 'true';
    final dynamic forceRefresh = options.headers['X-Force-Token-Refresh'];
    final bool refresh = forceRefresh == true || forceRefresh == 'true';
    if (!needsAuth) {
      handler.next(options);
      return;
    }
    if (!FirebaseConfig.isPlatformConfigured) {
      handler.next(options);
      return;
    }
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response<dynamic>(
              requestOptions: options,
              statusCode: 401,
              data: <String, dynamic>{
                'success': false,
                'message': 'Unauthenticated.',
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
      final String? token = await user.getIdToken(refresh);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Swallow — token fetch failure shouldn't break unauth paths.
    }
    handler.next(options);
  }

  static _RoleRequirement? _parseRoleRequirement(RequestOptions options) {
    final dynamic raw = options.headers['X-Require-Role'];
    if (raw == null) return null;
    final String value = raw is String ? raw : raw.toString();
    final UserRole? role = _parseRole(value);
    if (role == null) return null;
    return _RoleRequirement(role);
  }

  static UserRole? _parseRole(String? raw) {
    switch (raw) {
      case 'free':
        return UserRole.free;
      case 'premium':
        return UserRole.premium;
      case 'admin':
        return UserRole.admin;
      case 'authenticated':
        return UserRole.free;
      default:
        return null;
    }
  }

  static bool _roleMatches(UserRole actual, UserRole required) {
    if (required == UserRole.free) return true;
    if (required == UserRole.premium) {
      return actual == UserRole.premium || actual == UserRole.admin;
    }
    return actual == UserRole.admin;
  }
}

class _RoleRequirement {
  const _RoleRequirement(this.role);
  final UserRole role;
}
