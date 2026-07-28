import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/otp_request_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case: start the phone-OTP flow.
class SendPhoneOtpUseCase {
  const SendPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<OtpRequestEntity>> call({required String phoneNumber}) {
    return _repository.sendPhoneOtp(phoneNumber: phoneNumber);
  }
}