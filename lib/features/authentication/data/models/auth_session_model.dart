import '../../domain/entities/auth_session_entity.dart';
import 'user_model.dart';

/// Data-layer representation of [AuthSessionEntity].
class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  factory AuthSessionModel.fromEntity(AuthSessionEntity session) {
    return AuthSessionModel(
      user: UserModel.fromEntity(session.user),
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
    );
  }
}