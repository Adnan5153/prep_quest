import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/otp_request_entity.dart';
import '../../domain/entities/user_entity.dart';

/// High-level authentication status surfaced to the UI.
enum AuthStatus {
  /// Initial load — we have not yet asked the repository whether
  /// the user is signed in.
  unknown,

  /// No active session.
  unauthenticated,

  /// Profile is signed in but still missing required fields
  /// (display name, exam track).
  profileIncomplete,

  /// Waiting for the user to verify their email address.
  emailVerificationRequired,

  /// Fully authenticated and ready to use the app.
  authenticated,
}

/// Immutable value object describing the application's auth state.
@immutable
class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.session,
    this.pendingPhoneOtp,
    this.errorMessage,
    this.isWorking = false,
    this.lastSuccessMessage,
  });

  const AuthState.unknown()
      : status = AuthStatus.unknown,
        user = null,
        session = null,
        pendingPhoneOtp = null,
        errorMessage = null,
        isWorking = false,
        lastSuccessMessage = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        session = null,
        pendingPhoneOtp = null,
        errorMessage = null,
        isWorking = false,
        lastSuccessMessage = null;

  final AuthStatus status;
  final UserEntity? user;
  final AuthSessionEntity? session;
  final OtpRequestEntity? pendingPhoneOtp;
  final String? errorMessage;
  final String? lastSuccessMessage;
  final bool isWorking;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get needsProfileCompletion =>
      status == AuthStatus.profileIncomplete || _isProfileIncomplete;
  bool get needsEmailVerification =>
      status == AuthStatus.emailVerificationRequired;

  bool get _isProfileIncomplete {
    final UserEntity? current = user;
    if (current == null) return false;
    return !current.hasCompletedProfile;
  }

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    AuthSessionEntity? session,
    OtpRequestEntity? pendingPhoneOtp,
    bool clearPendingPhoneOtp = false,
    String? errorMessage,
    bool clearError = false,
    String? lastSuccessMessage,
    bool clearSuccess = false,
    bool? isWorking,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      session: session ?? this.session,
      pendingPhoneOtp: clearPendingPhoneOtp
          ? null
          : (pendingPhoneOtp ?? this.pendingPhoneOtp),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSuccessMessage: clearSuccess
          ? null
          : (lastSuccessMessage ?? this.lastSuccessMessage),
      isWorking: isWorking ?? this.isWorking,
    );
  }
}