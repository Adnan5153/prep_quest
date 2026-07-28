/// Lightweight provider exposing the phone-OTP request kept by the
/// auth controller.
///
/// The actual storage lives inside [AuthController]; this file is
/// kept so legacy imports (`import 'otp_provider.dart'`) keep
/// resolving without forcing the rest of the app onto the new path.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/auth_state.dart';
import 'auth_providers.dart';

/// Returns the in-flight phone-OTP request, or `null` when there is
/// none.
final pendingPhoneOtpProvider = Provider<Object?>((ref) {
  return ref.watch(
    authStateProvider.select((AuthState state) => state.pendingPhoneOtp),
  );
});