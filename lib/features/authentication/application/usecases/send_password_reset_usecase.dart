import '../../../../shared/typedefs/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: send a password-reset email to the supplied address.
class SendPasswordResetUseCase {
  const SendPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({required String email}) {
    return _repository.sendPasswordReset(email: email);
  }
}