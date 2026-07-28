import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: register a brand-new user with email + password and
/// display name.
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSessionEntity>> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _repository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}