/// Re-export of the application-layer phone-OTP start use case.
///
/// The repository contract surfaces a `sendPhoneOtp` method so we
/// keep this file as a thin alias for the canonical use case located
/// in `application/usecases/send_phone_otp_usecase.dart`. That way
/// existing imports keep working.
library;

export '../../application/usecases/send_phone_otp_usecase.dart'
    show SendPhoneOtpUseCase;
