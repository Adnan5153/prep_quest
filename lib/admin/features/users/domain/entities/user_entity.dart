import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.status,
    required this.mfaEnrolled,
    required this.lastLoginAt,
    required this.createdAt,
    required this.roles,
  });

  final String id;
  final String email;
  final String displayName;
  final UserStatus status;
  final bool mfaEnrolled;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final List<AdminRole> roles;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    UserStatus? status,
    bool? mfaEnrolled,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    List<AdminRole>? roles,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      mfaEnrolled: mfaEnrolled ?? this.mfaEnrolled,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      roles: roles ?? this.roles,
    );
  }
}

enum UserStatus { active, disabled, pending }

@immutable
class RoleDefinition {
  const RoleDefinition({
    required this.role,
    required this.displayName,
    required this.description,
  });

  final AdminRole role;
  final String displayName;
  final String description;
}
