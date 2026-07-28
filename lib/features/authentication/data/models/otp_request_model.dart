import '../../domain/entities/otp_request_entity.dart';

/// Data-layer representation of [OtpRequestEntity].
class OtpRequestModel {
  const OtpRequestModel({
    required this.verificationId,
    required this.phoneNumber,
    required this.expiresAt,
    required this.resendToken,
  });

  final String verificationId;
  final String phoneNumber;
  final DateTime expiresAt;
  final String resendToken;

  OtpRequestEntity toEntity() {
    return OtpRequestEntity(
      verificationId: verificationId,
      phoneNumber: phoneNumber,
      expiresAt: expiresAt,
      resendToken: resendToken,
    );
  }
}