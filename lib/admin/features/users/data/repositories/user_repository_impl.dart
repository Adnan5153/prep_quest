import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl() {
    _seed();
  }

  final Map<String, UserEntity> _users = <String, UserEntity>{};

  void _seed() {
    final DateTime now = DateTime.now();
    _users.addAll(<String, UserEntity>{
      'usr_admin': UserEntity(
        id: 'usr_admin',
        email: 'admin@prepquest.app',
        displayName: 'Platform Admin',
        status: UserStatus.active,
        mfaEnrolled: true,
        lastLoginAt: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(days: 200)),
        roles: <AdminRole>[AdminRole.admin],
      ),
      'usr_author': UserEntity(
        id: 'usr_author',
        email: 'author@prepquest.app',
        displayName: 'Author One',
        status: UserStatus.active,
        mfaEnrolled: true,
        lastLoginAt: now.subtract(const Duration(hours: 4)),
        createdAt: now.subtract(const Duration(days: 90)),
        roles: <AdminRole>[AdminRole.author],
      ),
      'usr_reviewer': UserEntity(
        id: 'usr_reviewer',
        email: 'reviewer@prepquest.app',
        displayName: 'Reviewer One',
        status: UserStatus.active,
        mfaEnrolled: true,
        lastLoginAt: now.subtract(const Duration(hours: 8)),
        createdAt: now.subtract(const Duration(days: 80)),
        roles: <AdminRole>[AdminRole.reviewer],
      ),
      'usr_publisher': UserEntity(
        id: 'usr_publisher',
        email: 'publisher@prepquest.app',
        displayName: 'Publisher One',
        status: UserStatus.active,
        mfaEnrolled: true,
        lastLoginAt: now.subtract(const Duration(hours: 12)),
        createdAt: now.subtract(const Duration(days: 70)),
        roles: <AdminRole>[AdminRole.publisher],
      ),
      'usr_auditor': UserEntity(
        id: 'usr_auditor',
        email: 'auditor@prepquest.app',
        displayName: 'Auditor One',
        status: UserStatus.active,
        mfaEnrolled: true,
        lastLoginAt: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 60)),
        roles: <AdminRole>[AdminRole.auditor],
      ),
      'usr_viewer': UserEntity(
        id: 'usr_viewer',
        email: 'viewer@prepquest.app',
        displayName: 'Viewer One',
        status: UserStatus.pending,
        mfaEnrolled: false,
        lastLoginAt: null,
        createdAt: now.subtract(const Duration(days: 1)),
        roles: <AdminRole>[AdminRole.viewer],
      ),
    });
  }

  @override
  Future<List<UserEntity>> listUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _users.values.toList()
      ..sort((UserEntity a, UserEntity b) => a.email.compareTo(b.email));
  }

  @override
  Future<UserEntity> assignRole(String userId, AdminRole role) async {
    final UserEntity? u = _users[userId];
    if (u == null) throw StateError('User not found');
    final List<AdminRole> next =
        <AdminRole>{...u.roles, role}.toList();
    final UserEntity updated = u.copyWith(roles: next);
    _users[userId] = updated;
    return updated;
  }

  @override
  Future<UserEntity> revokeRole(String userId, AdminRole role) async {
    final UserEntity? u = _users[userId];
    if (u == null) throw StateError('User not found');
    final List<AdminRole> next =
        u.roles.where((AdminRole r) => r != role).toList();
    final UserEntity updated = u.copyWith(roles: next);
    _users[userId] = updated;
    return updated;
  }

  @override
  Future<UserEntity> setStatus(String userId, UserStatus status) async {
    final UserEntity? u = _users[userId];
    if (u == null) throw StateError('User not found');
    final UserEntity updated = u.copyWith(status: status);
    _users[userId] = updated;
    return updated;
  }

  @override
  Future<List<RoleDefinition>> listRoleDefinitions() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return const <RoleDefinition>[
      RoleDefinition(
        role: AdminRole.viewer,
        displayName: 'Viewer',
        description: 'Read-only access to worlds, themes, assets.',
      ),
      RoleDefinition(
        role: AdminRole.author,
        displayName: 'Author',
        description: 'Edit drafts, manage themes, upload assets.',
      ),
      RoleDefinition(
        role: AdminRole.reviewer,
        displayName: 'Reviewer',
        description: 'Approve or reject drafts submitted for review.',
      ),
      RoleDefinition(
        role: AdminRole.publisher,
        displayName: 'Publisher',
        description: 'Promote tested drafts to Published; manage rollbacks.',
      ),
      RoleDefinition(
        role: AdminRole.admin,
        displayName: 'Admin',
        description: 'Manage users, roles, integrations, environment.',
      ),
      RoleDefinition(
        role: AdminRole.auditor,
        displayName: 'Auditor',
        description: 'Read-only access to audit, telemetry, exports.',
      ),
    ];
  }
}

final userRepositoryProvider = Provider<UserRepository>((Ref ref) {
  return UserRepositoryImpl();
});
