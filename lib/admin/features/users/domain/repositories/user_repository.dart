import '../../../../shared/enums/workflow_state.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> listUsers();
  Future<UserEntity> assignRole(String userId, AdminRole role);
  Future<UserEntity> revokeRole(String userId, AdminRole role);
  Future<UserEntity> setStatus(String userId, UserStatus status);
  Future<List<RoleDefinition>> listRoleDefinitions();
}
