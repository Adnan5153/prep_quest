import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.role,
    required this.issuedAt,
    required this.expiresAt,
    required this.mfaVerified,
    this.tenantId,
  });

  final String userId;
  final String email;
  final String displayName;
  final AdminRole role;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final bool mfaVerified;
  final String? tenantId;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isMfaRequired => !mfaVerified;

  AuthSession copyWith({
    String? displayName,
    AdminRole? role,
    DateTime? expiresAt,
    bool? mfaVerified,
    String? tenantId,
  }) {
    return AuthSession(
      userId: userId,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      issuedAt: issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      mfaVerified: mfaVerified ?? this.mfaVerified,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}

enum AuthStatus { unknown, unauthenticated, awaitingMfa, authenticated }

@immutable
class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  static const AuthState unknown = AuthState(status: AuthStatus.unknown);
  static const AuthState unauthenticated =
      AuthState(status: AuthStatus.unauthenticated);

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
    bool clearError = false,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
