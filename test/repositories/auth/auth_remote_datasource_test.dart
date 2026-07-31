import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/models/auth_session_model.dart';
import 'package:prep_quest/features/authentication/data/models/otp_request_model.dart';
import 'package:prep_quest/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

void main() {
  late MockAuthRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockAuthRemoteDataSource(latency: Duration.zero);
  });

  tearDown(() {
    dataSource.dispose();
  });

  test('MockAuthRemoteDataSource implements AuthRemoteDataSource', () {
    expect(dataSource, isA<AuthRemoteDataSource>());
  });

  group('signInWithEmail', () {
    test('returns an authenticated demo session', () async {
      final AuthSessionModel session = await dataSource.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );

      expect(session.user.id, 'demo-user');
      expect(session.user.email, 'demo@prepquest.app');
      expect(session.accessToken, isNotEmpty);
      expect(session.refreshToken, isNotEmpty);
      expect(session.expiresAt, isA<DateTime>());
    });

    test('rejects an invalid email address', () {
      expect(
        () => dataSource.signInWithEmail(
          email: 'invalid',
          password: FakeData.testPassword,
        ),
        throwsA(
          isA<AuthenticationFailure>()
              .having((AuthenticationFailure e) => e.code, 'code', 'invalid-email'),
        ),
      );
    });

    test('rejects a short password', () {
      expect(
        () => dataSource.signInWithEmail(
          email: FakeData.testEmail,
          password: 'short',
        ),
        throwsA(
          isA<AuthenticationFailure>().having(
            (AuthenticationFailure e) => e.code,
            'code',
            'invalid-credential',
          ),
        ),
      );
    });

    test('rejects unknown credentials', () {
      expect(
        () => dataSource.signInWithEmail(
          email: FakeData.testEmail,
          password: FakeData.testPassword,
        ),
        throwsA(isA<AuthenticationFailure>()),
      );
    });
  });

  group('registerWithEmail', () {
    test('creates and signs in a new account', () async {
      final AuthSessionModel session = await dataSource.registerWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(session.user.email, FakeData.testEmail);
      expect(session.user.displayName, FakeData.testName);
      expect(session.user.emailVerified, isFalse);
      expect((await dataSource.currentUser())?.id, session.user.id);
    });

    test('rejects malformed email', () {
      expect(
        () => dataSource.registerWithEmail(
          email: 'bad-email',
          password: FakeData.testPassword,
          displayName: FakeData.testName,
        ),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test('rejects weak password', () {
      expect(
        () => dataSource.registerWithEmail(
          email: FakeData.testEmail,
          password: 'abcdefgh',
          displayName: FakeData.testName,
        ),
        throwsA(
          isA<AuthenticationFailure>()
              .having((AuthenticationFailure e) => e.code, 'code', 'weak-password'),
        ),
      );
    });

    test('rejects duplicate email using case-insensitive lookup', () async {
      await dataSource.registerWithEmail(
        email: FakeData.testEmail,
        password: FakeData.testPassword,
        displayName: FakeData.testName,
      );

      expect(
        () => dataSource.registerWithEmail(
          email: FakeData.testEmail.toUpperCase(),
          password: FakeData.testPassword,
          displayName: FakeData.testName,
        ),
        throwsA(
          isA<AuthenticationFailure>().having(
            (AuthenticationFailure e) => e.code,
            'code',
            'email-already-in-use',
          ),
        ),
      );
    });
  });

  group('phone OTP', () {
    test('sendPhoneOtp returns normalized request data', () async {
      final OtpRequestModel request = await dataSource.sendPhoneOtp(
        phoneNumber: '01700-000000',
      );

      expect(request.verificationId, isNotEmpty);
      expect(request.phoneNumber, '01700000000');
      expect(request.resendToken, isNotEmpty);
      expect(request.expiresAt.isAfter(DateTime.now()), isTrue);
    });

    test('sendPhoneOtp rejects invalid phone number', () {
      expect(
        () => dataSource.sendPhoneOtp(phoneNumber: '123'),
        throwsA(
          isA<AuthenticationFailure>()
              .having((AuthenticationFailure e) => e.code, 'code', 'invalid-phone'),
        ),
      );
    });

    test('verifyPhoneOtp rejects unknown verification id', () {
      expect(
        () => dataSource.verifyPhoneOtp(
          verificationId: 'missing',
          otp: '123456',
        ),
        throwsA(
          isA<AuthenticationFailure>().having(
            (AuthenticationFailure e) => e.code,
            'code',
            'invalid-verification',
          ),
        ),
      );
    });

    test('verifyPhoneOtp rejects an incorrect OTP', () async {
      final OtpRequestModel request = await dataSource.sendPhoneOtp(
        phoneNumber: FakeData.testPhone,
      );

      expect(
        () => dataSource.verifyPhoneOtp(
          verificationId: request.verificationId,
          otp: '000000',
        ),
        throwsA(
          isA<AuthenticationFailure>()
              .having((AuthenticationFailure e) => e.code, 'code', 'invalid-otp'),
        ),
      );
    });
  });

  group('other auth operations', () {
    test('signInWithGoogle returns the demo account', () async {
      final AuthSessionModel session = await dataSource.signInWithGoogle();
      expect(session.user.email, 'demo@prepquest.app');
    });

    test('sendPasswordReset succeeds for known account', () async {
      await expectLater(
        dataSource.sendPasswordReset(email: 'demo@prepquest.app'),
        completes,
      );
    });

    test('sendPasswordReset rejects unknown account', () {
      expect(
        () => dataSource.sendPasswordReset(email: FakeData.testEmail),
        throwsA(
          isA<AuthenticationFailure>()
              .having((AuthenticationFailure e) => e.code, 'code', 'user-not-found'),
        ),
      );
    });

    test('resendEmailVerification requires signed-in user', () {
      expect(
        () => dataSource.resendEmailVerification(),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test('resendEmailVerification succeeds after sign in', () async {
      await dataSource.signInWithGoogle();
      await expectLater(dataSource.resendEmailVerification(), completes);
    });

    test('updateProfile requires signed-in user', () {
      expect(
        () => dataSource.updateProfile(
          displayName: FakeData.testName,
          examTrackId: 'bcs',
          district: FakeData.testDistrict,
        ),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test('updateProfile persists fields into account lookup', () async {
      await dataSource.signInWithEmail(
        email: 'demo@prepquest.app',
        password: 'Password1',
      );

      final UserModel updated = await dataSource.updateProfile(
        displayName: FakeData.testName,
        examTrackId: 'bank',
        district: FakeData.testDistrict,
        phoneNumber: FakeData.testPhone,
      );
      await dataSource.signOut();
      final AuthSessionModel signedIn = await dataSource.signInWithEmail(
        email: 'DEMO@PREPQUEST.APP',
        password: 'Password1',
      );

      expect(updated.displayName, FakeData.testName);
      expect(signedIn.user.examTrackId, 'bank');
      expect(signedIn.user.district, FakeData.testDistrict);
      expect(signedIn.user.phoneNumber, FakeData.testPhone);
    });

    test('signOut clears current user', () async {
      await dataSource.signInWithGoogle();
      await dataSource.signOut();
      expect(await dataSource.currentUser(), isNull);
    });
  });

  test('configured latency delays completion', () async {
    final MockAuthRemoteDataSource delayed = MockAuthRemoteDataSource(
      latency: const Duration(milliseconds: 30),
    );
    addTearDown(delayed.dispose);
    final Stopwatch stopwatch = Stopwatch()..start();

    await delayed.currentUser();
    stopwatch.stop();

    expect(stopwatch.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 20)));
  });
}
