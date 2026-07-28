import '../../../../shared/typedefs/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: sign out the current user.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() {
    return _repository.signOut();
  }
}