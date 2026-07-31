import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/models/auth_session_model.dart';
import 'package:prep_quest/features/authentication/data/models/otp_request_model.dart';
import 'package:prep_quest/features/authentication/data/models/user_model.dart';
import 'package:prep_quest/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:prep_quest/features/authentication/domain/entities/auth_session_entity.dart';
import 'package:prep_quest/features/authentication/domain/entities/otp_request_entity.dart';
import 'package:prep_quest/features/authentication/domain/entities/user_entity.dart';
import 'package:prep_quest/shared/enums/exam_track.dart';
import 'package:prep_quest/shared/typedefs/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

/// Helper data source that always throws [error] for any call. We use it
/// to drive the repository's error-mapping branches.
class _ThrowingDataSource implements AuthRemoteDataSource {
  _ThrowingDataSource(this.error);

  final Object error;

  Never _throw() => throw error;

  @override
  Stream<UserModel?> authStateChanges() => const Stream<UserModel?>.empty();

  @override
  Stream<UserModel?> idTokenChanges() => const Stream<UserModel?>.empty();

  @override
  Future<UserModel?> currentUser() async => _throw();

  @override
  Future<AuthSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) async =>
      _throw();

  @override
  Future<AuthSessionModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async =>
      _throw();

  @override
  Future<void> sendPasswordReset({required String email}) async => _throw();

  @override
  Future<OtpRequestModel> sendPhoneOtp({required String phoneNumber}) async =>
      _throw();

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async =>
      _throw();

  @override
  Future<AuthSessionModel> signInWithGoogle() async => _throw();

  @override
  Future<AuthSessionModel> signInAnonymous() async => _throw();

  @override
  Future<AuthSessionModel> linkAnonymousWithCredential({
    required String email,
    required String password,
    required String displayName,
  }) async =>
      _throw();

  @override
  Future<AuthSessionModel> linkAnonymousWithGoogle() async => _throw();

  @override
  Future<void> resendEmailVerification() async => _throw();

  @override
  Future<UserModel> reloadUser() async => _throw();

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    required String examTrackId,
    required String district,
    String phoneNumber = '',
  }) async =>
      _throw();

  @override
  Future<void> signOut() async => _throw();
}

void main() {
  late MockAuthRemoteDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = MockAuthRemoteDataSource(latency: Duration.zero);
    repository = AuthRepositoryImpl(dataSource);
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('currentUser', () {
    test('returns null when no user is signed in', () async {
      final Result<UserEntity?> result = await repository.currentUser();
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('returns the domain entity after sign-in', () async {
      await dataSource.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );
      final Result<UserEntity?> result = await repository.currentUser();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isA<UserEntity>());
      expect(result.valueOrNull?.email, 'demo@prepquest.app');
      expect(result.valueOrNull?.examTrack, ExamTrack.bcs);
    });
  });

  group('signInWithEmail', () {
    test('returns success with AuthSessionEntity on demo account', () async {
      final Result<AuthSessionEntity> result = await repository.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isA<AuthSessionEntity>());
      expect(result.valueOrNull?.user.email, 'demo@prepquest.app');
      expect(result.valueOrNull?.accessToken, isNotEmpty);
    });

    test('maps AuthenticationFailure for invalid credentials', () async {
      final Result<AuthSessionEntity> result = await repository.signInWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthenticationFailure>());
    });

    test('maps FirebaseAuthException to AuthenticationFailure', () async {
      final AuthRepositoryImpl localRepo = AuthRepositoryImpl(
        _ThrowingDataSource(
          FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found',
          ),
        ),
      );

      final Result<AuthSessionEntity> result = await localRepo.signInWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
      );

      expect(result.failureOrNull, isA<AuthenticationFailure>());
      expect(
        (result.failureOrNull! as AuthenticationFailure).code,
        'user-not-found',
      );
    });
  });

  group('registerWithEmail', () {
    test('returns an authenticated session for a new user', () async {
      final Result<AuthSessionEntity> result = await repository.registerWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.user.displayName, FakeData.testName);
    });

    test('fails when the email is already registered', () async {
      await repository.registerWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );
      final Result<AuthSessionEntity> second = await repository.registerWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(second.isFailure, isTrue);
      expect(second.failureOrNull, isA<AuthenticationFailure>());
    });
  });

  group('phone OTP', () {
    test('sendPhoneOtp returns entity with 5-min expiry', () async {
      final Result<OtpRequestEntity> result = await repository.sendPhoneOtp(
        phoneNumber: FakeData.testPhone,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.expiresAt.isAfter(DateTime.now()), isTrue);
    });

    test('verifyPhoneOtp fails with invalid-verification code', () async {
      final Result<AuthSessionEntity> result = await repository.verifyPhoneOtp(
        verificationId: 'missing',
        otp: '000000',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthenticationFailure>());
    });
  });

  group('signInWithGoogle', () {
    test('returns demo session', () async {
      final Result<AuthSessionEntity> result = await repository.signInWithGoogle();
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.user.email, 'demo@prepquest.app');
    });
  });

  group('signInAnonymous', () {
    test('returns a guest session', () async {
      final Result<AuthSessionEntity> result =
          await repository.signInAnonymous();
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.user.email, isEmpty);
      expect(result.valueOrNull?.user.displayName, 'Guest Learner');
    });
  });

  group('linkAnonymousWithCredential', () {
    test('promotes the guest to a permanent account', () async {
      await repository.signInAnonymous();

      final Result<AuthSessionEntity> result =
          await repository.linkAnonymousWithCredential(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.user.email, FakeData.testEmail);
      expect(result.valueOrNull?.user.displayName, FakeData.testName);
    });

    test('fails when no guest session is active', () async {
      final Result<AuthSessionEntity> result =
          await repository.linkAnonymousWithCredential(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthenticationFailure>());
    });
  });

  group('signOut', () {
    test('clears current user', () async {
      await dataSource.signInWithGoogle();

      final Result<void> result = await repository.signOut();
      expect(result.isSuccess, isTrue);
      expect(await dataSource.currentUser(), isNull);
    });
  });

  group('updateProfile', () {
    test('persists profile fields for the signed-in user', () async {
      await dataSource.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );

      final Result<UserEntity> result = await repository.updateProfile(
        displayName: FakeData.testName,
        examTrackId: ExamTrack.bcs.id,
        district: FakeData.testDistrict,
        phoneNumber: FakeData.testPhone,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.displayName, FakeData.testName);
      expect(result.valueOrNull?.district, FakeData.testDistrict);
    });

    test('returns failure when no user is signed in', () async {
      final Result<UserEntity> result = await repository.updateProfile(
        displayName: FakeData.testName,
        examTrackId: ExamTrack.bcs.id,
        district: FakeData.testDistrict,
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthenticationFailure>());
    });
  });

  group('authStateChanges', () {
    test('emits UserEntity? values when the underlying stream fires', () async {
      final List<UserEntity?> events = <UserEntity?>[];
      final StreamSubscription<UserEntity?> sub = repository
          .authStateChanges()
          .listen(events.add);

      await Future<void>.delayed(Duration.zero);
      await repository.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );
      await Future<void>.delayed(Duration.zero);
      await repository.signOut();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(events.where((UserEntity? u) => u != null), isNotEmpty);
      expect(events.last, isNull);
    });
  });

  group('error mapping', () {
    test('TimeoutException maps to NetworkFailure', () async {
      final AuthRepositoryImpl localRepo =
          AuthRepositoryImpl(_ThrowingDataSource(TimeoutException('net')));

      final Result<UserEntity?> result = await localRepo.currentUser();
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('FormatException maps to ValidationFailure', () async {
      final AuthRepositoryImpl localRepo =
          AuthRepositoryImpl(_ThrowingDataSource(const FormatException('bad')));

      final Result<UserEntity?> result = await localRepo.currentUser();
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('FirebaseAuthException operation-not-allowed maps to AuthorizationFailure',
        () async {
      final AuthRepositoryImpl localRepo = AuthRepositoryImpl(
        _ThrowingDataSource(
          FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'not allowed',
          ),
        ),
      );

      final Result<AuthSessionEntity> result = await localRepo.signInWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
      );

      expect(result.failureOrNull, isA<AuthorizationFailure>());
    });
  });
}