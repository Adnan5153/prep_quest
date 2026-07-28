import '../../../../shared/typedefs/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: re-send the verification email for the current user.
class ResendEmailVerificationUseCase {
  const ResendEmailVerificationUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() {
    return _repository.resendEmailVerification();
  }
}