import '../../../../shared/typedefs/result.dart';
import '../entities/auth_session_entity.dart';
import '../entities/otp_request_entity.dart';
import '../entities/user_entity.dart';

/// Contract every authentication repository must satisfy.
///
/// Repositories are pure abstractions: they return [Result]s instead
/// of throwing so the application/presentation layer can branch
/// without try/catch noise. The data layer (`data/repositories/`)
/// provides the implementation that talks to the remote provider
/// (Firebase today, mock during early development).
abstract class AuthRepository {
  /// Stream of authentication state changes.
  ///
  /// Emits the current user when signed in (or after a profile
  /// refresh) and `null` when signed out. Implementations may emit
  /// additional loading events, but the canonical shape is
  /// [UserEntity?] where `null == signed-out`.
  Stream<UserEntity?> authStateChanges();

  /// Returns the currently authenticated user, or `null` if no
  /// session is active. Implementations must read from the local
  /// cache to remain synchronous.
  Future<Result<UserEntity?>> currentUser();

  /// Signs the user in with email + password.
  Future<Result<AuthSessionEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates a new account using email + password.
  ///
  /// On success the provider also dispatches an email-verification
  /// email; the user must confirm ownership before completing the
  /// profile.
  Future<Result<AuthSessionEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs the user in via Google.
  ///
  /// The returned [UserEntity] carries the identity fields Google
  /// provides at sign-in (display name, email, photo URL, verified
  /// flag) plus the default `examTrack = ExamTrack.other` so the
  /// router still routes a brand-new user through the
  /// profile-completion screen on first sign-in.
  Future<Result<AuthSessionEntity>> signInWithGoogle();

  /// Sends a password-reset email to [email].
  Future<Result<void>> sendPasswordReset({required String email});

  /// Starts a phone-OTP flow by requesting a verification code.
  Future<Result<OtpRequestEntity>> sendPhoneOtp({
    required String phoneNumber,
  });

  /// Confirms the OTP code issued for [verificationId] and signs the
  /// user in.
  Future<Result<AuthSessionEntity>> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  });

  /// Re-sends the verification email for the currently signed-in
  /// user.
  Future<Result<void>> resendEmailVerification();

  /// Marks the email as verified locally. The remote provider is
  /// expected to re-issue the verification token before the next
  /// call.
  Future<Result<void>> reloadUser();

  /// Persists the post-sign-up profile details (display name, exam
  /// track, district, etc.).
  Future<Result<UserEntity>> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber,
  });

  /// Signs the current user out, clears cached state and emits the
  /// signed-out event on [authStateChanges].
  Future<Result<void>> signOut();
}