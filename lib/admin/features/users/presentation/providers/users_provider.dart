import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

final usersListProvider = FutureProvider<List<UserEntity>>((Ref ref) {
  return ref.watch(userRepositoryProvider).listUsers();
});

final roleDefinitionsProvider =
    FutureProvider<List<RoleDefinition>>((Ref ref) {
  return ref.watch(userRepositoryProvider).listRoleDefinitions();
});

class UsersController {
  const UsersController(this.ref);

  final Ref ref;

  Future<void> toggleRole({
    required String userId,
    required AdminRole role,
    required bool assign,
  }) async {
    if (assign) {
      await ref.read(userRepositoryProvider).assignRole(userId, role);
    } else {
      await ref.read(userRepositoryProvider).revokeRole(userId, role);
    }
    ref.invalidate(usersListProvider);
  }

  Future<void> setStatus({
    required String userId,
    required UserStatus status,
  }) async {
    await ref.read(userRepositoryProvider).setStatus(userId, status);
    ref.invalidate(usersListProvider);
  }
}

final usersControllerProvider =
    Provider<UsersController>((Ref ref) => UsersController(ref));
