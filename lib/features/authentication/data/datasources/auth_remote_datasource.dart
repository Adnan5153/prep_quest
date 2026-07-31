import '../models/auth_session_model.dart';
import '../models/otp_request_model.dart';
import '../models/user_model.dart';

/// Contract every auth remote data source must satisfy.
///
/// Two implementations exist:
/// * [FirebaseAuthRemoteDataSource] — talks to Firebase Auth / Firestore.
/// * [MockAuthRemoteDataSource] — in-memory replacement used during
///   development and tests. The implementation lives in the same
///   folder so swapping them out is a matter of changing the
///   Riverpod override in `presentation/providers/auth_providers.dart`.
abstract class AuthRemoteDataSource {
  Stream<UserModel?> authStateChanges();

  Future<UserModel?> currentUser();

  Future<AuthSessionModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs the user in via Google.
  ///
  /// Returns an [AuthSessionModel] whose [UserModel] carries the
  /// fields Google reports at sign-in time (display name, email,
  /// photo URL, `emailVerified: true`). `examTrackId` is left at the
  /// default (`ExamTrack.other`) so the router continues to send the
  /// user through the profile-completion flow on first sign-in and
  /// skips it on subsequent sign-ins once [updateProfile] has been
  /// called.
  Future<AuthSessionModel> signInWithGoogle();

  Future<void> sendPasswordReset({required String email});

  Future<OtpRequestModel> sendPhoneOtp({required String phoneNumber});

  Future<AuthSessionModel> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  });

  Future<void> resendEmailVerification();

  Future<UserModel> reloadUser();

  Future<UserModel> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber,
  });

  Future<void> signOut();
}