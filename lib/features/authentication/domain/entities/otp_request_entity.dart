import 'package:flutter/foundation.dart';

/// Outgoing one-time-password request. Used to communicate between
/// the presentation layer and the application/domain layers without
/// leaking transport primitives (e.g. Firebase's
/// `PhoneAuthCredential`).
@immutable
class OtpRequestEntity {
  const OtpRequestEntity({
    required this.verificationId,
    required this.phoneNumber,
    required this.expiresAt,
    required this.resendToken,
  });

  final String verificationId;
  final String phoneNumber;
  final DateTime expiresAt;
  final String resendToken;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  OtpRequestEntity copyWith({
    String? verificationId,
    String? phoneNumber,
    DateTime? expiresAt,
    String? resendToken,
  }) {
    return OtpRequestEntity(
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      expiresAt: expiresAt ?? this.expiresAt,
      resendToken: resendToken ?? this.resendToken,
    );
  }
}