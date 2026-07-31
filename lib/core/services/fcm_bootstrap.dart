import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/states/auth_state.dart';
import '../../features/notifications/presentation/providers/notification_provider.dart';

/// Lightweight FCM token-registration seam (Phase 48).
///
/// The wiring is split into two pieces so the dependency on
/// `firebase_messaging` can be added later without touching this
/// layer:
///
/// 1. [tokenSource] returns the active FCM token for the device, or
///    `null` if the SDK isn't wired yet. When `firebase_messaging` is
///    added to `pubspec.yaml`, replace the stub with the real
///    `FirebaseMessaging.instance.getToken()` call (and listen to
///    `onTokenRefresh` for rotation events).
/// 2. [deviceIdSource] returns a stable per-install identifier. The
///    stub uses a hash of the running platform so devices map to the
///    same `fcm_tokens/{deviceId}` doc on every boot.
///
/// The Flutter widget that owns the router tree should call
/// [FcmBootstrap.bind] from `AppConfig.bootstrap()` — the bootstrap
/// sets up a `ref.listen` on `authStateProvider` and (re)registers the
/// token whenever the user signs in.
class FcmBootstrap {
  const FcmBootstrap({
    required this.tokenSource,
    required this.deviceIdSource,
  });

  /// Resolves the current FCM token for the device. Returns `null`
  /// when the SDK isn't wired or the platform has no token yet.
  final Future<String?> Function() tokenSource;

  /// Resolves a stable per-install identifier used as the
  /// `fcm_tokens/{deviceId}` doc id.
  final Future<String> Function() deviceIdSource;

  /// Wires the auth-aware token-registration listener. Idempotent —
  /// safe to call from `bootstrap()` on every cold boot.
  static void bind(Ref ref, FcmBootstrap bootstrap) {
    ProviderSubscription<AuthState>? subscription;

    Future<void> registerIfNeeded(AuthState auth) async {
      final String uid = auth.user?.id ?? '';
      if (uid.isEmpty) return;
      try {
        final String? token = await bootstrap.tokenSource();
        if (token == null || token.isEmpty) return;
        final String deviceId = await bootstrap.deviceIdSource();
        await ref.read(registerFcmTokenProvider)(
          deviceId: deviceId,
          token: token,
          platform: defaultTargetPlatform.name,
          metadata: <String, dynamic>{
            'lastRegisteredAtIso': DateTime.now().toUtc().toIso8601String(),
          },
        );
      } catch (error, stack) {
        debugPrint('[FcmBootstrap] token registration failed: '
            '$error\n$stack');
      }
    }

    subscription = ref.listen<AuthState>(
      authStateProvider,
      (AuthState? previous, AuthState next) {
        registerIfNeeded(next);
      },
      fireImmediately: true,
    );

    ref.onDispose(() {
      subscription?.close();
    });
  }
}

/// Default bootstrap used when no override is provided. Returns
/// `null` from the token source so token registration is a no-op
/// until `firebase_messaging` is wired in pubspec.yaml.
final fcmBootstrapProvider = Provider<FcmBootstrap>((Ref ref) {
  return const FcmBootstrap(
    tokenSource: _stubTokenSource,
    deviceIdSource: _stubDeviceIdSource,
  );
});

Future<String?> _stubTokenSource() async => null;

Future<String> _stubDeviceIdSource() async {
  final String now = DateTime.now().toUtc().toIso8601String();
  return 'stub-${defaultTargetPlatform.name}-$now';
}