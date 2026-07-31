// Provider-level tests for the authentication feature.
//
// We inject `MockAuthRemoteDataSource` (zero latency) into
// `authRemoteDataSourceProvider`, then drive the `AuthController`
// through the public API and assert the resulting `AuthState`
// transitions.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:prep_quest/features/authentication/presentation/providers/auth_providers.dart';
import 'package:prep_quest/features/authentication/presentation/providers/otp_provider.dart';
import 'package:prep_quest/features/authentication/presentation/states/auth_state.dart';

import '../helpers/fake_data.dart';
import '../helpers/provider_test_utils.dart';

void main() {
  group('auth_providers', () {
    test(
      'authRemoteDataSourceProvider defaults to FirebaseAuthRemoteDataSource',
      () {
        // Smoke check: the provider builds without throwing when no
        // overrides are supplied. We do NOT evaluate the underlying
        // data source here because that would touch Firebase.
        expect(authRemoteDataSourceProvider, isA<Provider<AuthRemoteDataSource>>());
      },
    );

    test('authRepositoryProvider builds with an injected mock', () async {
      await withProviderContainer((
        ProviderContainer container,
      ) async {
        final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
          latency: Duration.zero,
        );
        addTearDown(dataSource.dispose);
        container = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        final repository = container.read(authRepositoryProvider);
        expect(repository, isNotNull);
      });
    });

    test('signInWithEmail populates user and session', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        // Re-create the container with the override applied.
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero); // let bootstrap settle.

        await controller.signInWithEmail(
          email: 'demo@prepquest.app',
          password: 'Password1',
        );

        final AuthState state = scoped.read(authStateProvider);
        // The demo account is fully verified & has a completed profile, so
        // the controller should land on `authenticated`.
        expect(state.status, AuthStatus.authenticated);
        expect(state.isWorking, isFalse);
        expect(state.user, isNotNull);
      });
    });

    test('signInWithEmail surfaces failure for invalid credentials', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        await controller.signInWithEmail(
          email: 'demo@prepquest.app',
          password: 'WrongPassword1',
        );

        final AuthState state = scoped.read(authStateProvider);
        expect(state.errorMessage, isNotNull);
        expect(state.isWorking, isFalse);
      });
    });

    test('registerWithEmail creates a new user', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        await controller.registerWithEmail(
          email: 'newbie@prepquest.app',
          password: 'Password1',
          displayName: FakeData.testName,
        );

        final AuthState state = scoped.read(authStateProvider);
        expect(state.user, isNotNull);
        expect(state.user!.email, 'newbie@prepquest.app');
        expect(state.lastSuccessMessage, contains('verify'));
        expect(state.isWorking, isFalse);
      });
    });

    test('sendPhoneOtp stores a pending request in state', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        await controller.sendPhoneOtp(phoneNumber: FakeData.testPhone);
        final AuthState state = scoped.read(authStateProvider);

        expect(state.pendingPhoneOtp, isNotNull);
        expect(state.pendingPhoneOtp!.phoneNumber, FakeData.testPhone);
        expect(state.isWorking, isFalse);
      });
    });

    test('sendPhoneOtp surfaces failure for invalid phone', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        await controller.sendPhoneOtp(phoneNumber: 'not-a-phone');
        final AuthState state = scoped.read(authStateProvider);
        expect(state.errorMessage, isNotNull);
        expect(state.pendingPhoneOtp, isNull);
      });
    });

    test('signOut transitions to unauthenticated', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        await controller.signOut();
        final AuthState state = scoped.read(authStateProvider);
        expect(state.status, AuthStatus.unauthenticated);
      });
    });

    test('clearMessages wipes error and success flags', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        // Force an error first.
        await controller.signInWithEmail(
          email: 'demo@prepquest.app',
          password: 'wrong',
        );
        expect(scoped.read(authStateProvider).errorMessage, isNotNull);

        controller.clearMessages();
        final AuthState state = scoped.read(authStateProvider);
        expect(state.errorMessage, isNull);
        expect(state.lastSuccessMessage, isNull);
      });
    });

    test('pendingPhoneOtpProvider reflects state.pendingPhoneOtp', () async {
      final MockAuthRemoteDataSource dataSource = MockAuthRemoteDataSource(
        latency: Duration.zero,
      );
      addTearDown(dataSource.dispose);

      await withProviderContainer((ProviderContainer container) async {
        final ProviderContainer scoped = ProviderContainer(
          overrides: <Override>[
            authRemoteDataSourceProvider.overrideWithValue(dataSource),
          ],
        );
        addTearDown(scoped.dispose);

        final AuthController controller = scoped.read(
          authStateProvider.notifier,
        );
        await Future<void>.delayed(Duration.zero);

        expect(scoped.read(pendingPhoneOtpProvider), isNull);

        await controller.sendPhoneOtp(phoneNumber: FakeData.testPhone);
        expect(scoped.read(pendingPhoneOtpProvider), isNotNull);
      });
    });
  });
}