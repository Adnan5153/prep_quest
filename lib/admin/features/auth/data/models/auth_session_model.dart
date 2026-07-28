import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.userId,
    required super.email,
    required super.displayName,
    required super.role,
    required super.issuedAt,
    required super.expiresAt,
    required super.mfaVerified,
    super.tenantId,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: AdminRole.fromWire(json['role'] as String),
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      mfaVerified: json['mfaVerified'] as bool? ?? false,
      tenantId: json['tenantId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'role': role.wire,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'mfaVerified': mfaVerified,
      'tenantId': tenantId,
    };
  }
}
