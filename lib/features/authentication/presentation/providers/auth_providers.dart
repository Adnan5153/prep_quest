import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../router.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/mock_auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../states/auth_state.dart';

/// Provider for the remote data source.
///
/// Defaults to the in-memory mock so the app boots without the
/// Firebase SDK installed. Production overrides this with
/// `FirebaseAuthRemoteDataSource` once the SDK is wired up.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
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