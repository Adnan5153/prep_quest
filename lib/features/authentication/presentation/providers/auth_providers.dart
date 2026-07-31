import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../router.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/firebase_auth_remote_datasource.dart';
import '../../data/datasources/mock_auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../states/auth_state.dart';

/// Provider for the remote data source.
///
/// Returns the **real** [FirebaseAuthRemoteDataSource] whenever
/// [FirebaseConfig.isPlatformConfigured] is `true` — every sign-in
/// path then reads + writes Firestore (`users/{uid}`,
/// `users/{uid}/profile/current`, `users/{uid}/app_user/current`).
/// When Firebase has not been initialised (e.g. unit tests, hot-reload
/// sessions, or a fresh dev machine without `google-services.json`)
/// the provider falls back to [MockAuthRemoteDataSource] so the
/// app still boots — but the mock no longer auto-bootstraps a demo
/// user, so even mock sign-in has to go through the explicit
/// `signInWithGoogle` / `signInWithEmail` / etc. flow.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (FirebaseConfig.isPlatformConfigured) {
    return const FirebaseAuthRemoteDataSource();
  }
  final MockAuthRemoteDataSource instance = MockAuthRemoteDataSource();
  ref.onDispose(() => instance.dispose());
  return instance;
});

/// Provider for the repository contract.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

/// Highest-level auth state — backed by the controller.
final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);

/// Notifier that fires whenever the auth state changes. The router
/// listens to this so every transition re-runs the redirect logic.
final authRouterRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  ref.listen<AuthState>(authStateProvider, (AuthState? previous, AuthState next) {
    AuthRouterBridge.emit(next);
    notifier.value++;
  });
  ref.onDispose(notifier.dispose);
  return notifier;
});