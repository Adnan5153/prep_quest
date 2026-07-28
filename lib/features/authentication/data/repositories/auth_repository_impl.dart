import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/otp_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete [AuthRepository] backed by an [AuthRemoteDataSource].
///
/// Every public method follows the same pattern:
///   1. delegate to the remote data source,
///   2. wrap exceptions via [ErrorHandler.map],
///   3. return a [Result] so callers never see raw exceptions.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remote.authStateChanges().map(
          (user) => user?.toEntity(),
        );
  }

  @override
  Future<Result<UserEntity?>> currentUser() async {
    try {
      final user = await _remote.currentUser();
      return Result.success(user?.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<AuthSessionEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remote.signInWithEmail(
        email: email,
        password: password,
      );
      return Result.success(session.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<AuthSessionEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final session = await _remote.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Result.success(session.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> sendPasswordReset({required String email}) async {
    try {
      await _remote.sendPasswordReset(email: email);
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<OtpRequestEntity>> sendPhoneOtp({
    required String phoneNumber,
  }) async {
    try {
      final request = await _remote.sendPhoneOtp(phoneNumber: phoneNumber);
      return Result.success(request.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<AuthSessionEntity>> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final session = await _remote.verifyPhoneOtp(
        verificationId: verificationId,
        otp: otp,
      );
      return Result.success(session.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> resendEmailVerification() async {
    try {
      await _remote.resendEmailVerification();
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> reloadUser() async {
    try {
      await _remote.reloadUser();
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<UserEntity>> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) async {
    try {
      final updated = await _remote.updateProfile(
        displayName: displayName,
        examTrackId: examTrackId,
        district: district,
        phoneNumber: phoneNumber,
      );
      return Result.success(updated.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remote.signOut();
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }
}