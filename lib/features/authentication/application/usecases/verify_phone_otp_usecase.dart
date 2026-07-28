import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: confirm a phone-OTP code and complete sign-in.
class VerifyPhoneOtpUseCase {
  const VerifyPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSessionEntity>> call({
    required String verificationId,
    required String otp,
  }) {
    return _repository.verifyPhoneOtp(
      verificationId: verificationId,
      otp: otp,
    );
  }
}