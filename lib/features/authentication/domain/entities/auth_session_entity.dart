import 'package:flutter/foundation.dart';

import 'user_entity.dart';

/// Result of an authentication attempt that yields a fresh session
/// (sign-in, register, OTP verification). The session wraps the
/// authenticated user and the bearer token the data layer issued.
@immutable
class AuthSessionEntity {
  const AuthSessionEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthSessionEntity copyWith({
    UserEntity? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthSessionEntity(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthSessionEntity &&
        other.user == user &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => Object.hash(user, accessToken, refreshToken, expiresAt);
}