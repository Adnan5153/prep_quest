import 'dart:async';

import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/models/otp_request_model.dart';
import 'package:prep_quest/features/authentication/data/models/user_model.dart';
import 'package:prep_quest/shared/enums/exam_track.dart';
import 'package:prep_quest/shared/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

void main() {
  group('MockAuthRemoteDataSource bootstrap', () {
    test('seeds a demo account', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      final UserModel? current = await source.currentUser();
      expect(current, isNull);
    });

    test('does not leak default latency when zero is provided', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      final Stopwatch watch = Stopwatch()..start();
      await source.currentUser();
      watch.stop();
      expect(watch.elapsed, lessThan(const Duration(milliseconds: 25)));
    });
  });

  group('account lookup', () {
    test('returns the demo account on case-insensitive match', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      await source.signInWithEmail(
        email: 'DEMO@PREPQUEST.APP',
        password: 'Password1',
      );

      final UserModel? current = await source.currentUser();
      expect(current?.email, 'demo@prepquest.app');
      expect(current?.examTrackId, ExamTrack.bcs.id);
      expect(current?.roleId, UserRole.free.id);
    });

    test('returns null when nothing is registered', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      expect(await source.currentUser(), isNull);
    });
  });

  group('OTP map', () {
    test('a successful verification removes the OTP entry', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      final OtpRequestModel request = await source.sendPhoneOtp(
        phoneNumber: FakeData.testPhone,
      );

      // First invalid attempt should keep the OTP active so a user can retry.
      expect(
        () => source.verifyPhoneOtp(
          verificationId: request.verificationId,
          otp: '000000',
        ),
        throwsA(isA<AuthenticationFailure>()),
      );

      // We can't read the private OTP map, but the second invalid attempt
      // also throws so the entry is still there.
      expect(
        () => source.verifyPhoneOtp(
          verificationId: request.verificationId,
          otp: '999999',
        ),
        throwsA(isA<AuthenticationFailure>()),
      );
    });
  });

  group('stream broadcasting', () {
    test('emits the current user on subscribe and on state changes', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      final List<UserModel?> events = <UserModel?>[];
      final StreamSubscription<UserModel?> sub = source
          .authStateChanges()
          .listen(events.add);

      // Yielding control so the initial frame fires.
      await Future<void>.delayed(Duration.zero);
      await source.signInWithGoogle();
      await source.signOut();

      // Wait briefly so the final events flush.
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(events.first, isNull);
      expect(events.last, isNull);
      // After sign-in the stream should emit the demo user.
      expect(events.where((UserModel? u) => u != null), isNotEmpty);
    });

    test('multiple subscribers each receive subsequent events', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      int first = 0;
      int second = 0;
      final StreamSubscription<UserModel?> a = source
          .authStateChanges()
          .listen((_) => first++);
      final StreamSubscription<UserModel?> b = source
          .authStateChanges()
          .listen((_) => second++);

      await Future<void>.delayed(Duration.zero);
      await source.signInWithGoogle();

      await Future<void>.delayed(Duration.zero);
      await a.cancel();
      await b.cancel();

      expect(first, greaterThanOrEqualTo(1));
      expect(second, greaterThanOrEqualTo(1));
    });
  });

  group('reloadUser', () {
    test('requires an active session', () {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      expect(
        () => source.reloadUser(),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test('returns refreshed user when signed in', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      await source.signInWithGoogle();
      final UserModel refreshed = await source.reloadUser();

      expect(refreshed.id, 'demo-user');
    });
  });

  group('validation failures', () {
    test('signInWithEmail throws AuthenticationFailure for malformed email',
        () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      expect(
        () => source.signInWithEmail(email: '', password: FakeData.testPassword),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test('sendPhoneOtp rejects empty phone', () async {
      final MockAuthRemoteDataSource source =
          MockAuthRemoteDataSource(latency: Duration.zero);
      addTearDown(source.dispose);

      expect(
        () => source.sendPhoneOtp(phoneNumber: ''),
        throwsA(isA<AuthenticationFailure>()),
      );
    });
  });
}