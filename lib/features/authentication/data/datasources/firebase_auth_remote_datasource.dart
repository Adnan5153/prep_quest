import '../../../../core/errors/failures.dart';
import '../models/auth_session_model.dart';
import '../models/otp_request_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Firebase Auth + Firestore implementation placeholder.
///
/// This class is wired into the repository layer so the app boots
/// without the Firebase SDK installed, while leaving a single seam
/// to swap in the real implementation once `firebase_auth` /
/// `cloud_firestore` are added to `pubspec.yaml` and configured for
/// each platform.
///
/// To activate:
/// 1. Add `firebase_auth` and `cloud_firestore` to `pubspec.yaml`.
/// 2. Replace every `throw` with the corresponding Firebase call.
/// 3. Update `presentation/providers/auth_providers.dart` so the
///    Riverpod override resolves to [FirebaseAuthRemoteDataSource].
/// 4. Initialise Firebase in `lib/core/config/firebase_config.dart`
///    and call `Firebase.initializeApp(...)` inside `AppConfig.bootstrap`.
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const FirebaseAuthRemoteDataSource();

  @override
  Stream<UserModel?> authStateChanges() {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<UserModel?> currentUser() {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<AuthSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<AuthSessionModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<void> sendPasswordReset({required String email}) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<OtpRequestModel> sendPhoneOtp({required String phoneNumber}) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<void> resendEmailVerification() {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<UserModel> reloadUser() {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }

  @override
  Future<void> signOut() {
    throw const AuthenticationFailure(
      'Firebase auth has not been initialised. Use the mock data source.',
      code: 'not-configured',
    );
  }
}