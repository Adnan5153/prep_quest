import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/states/auth_state.dart';
import '../../shared/enums/user_role.dart';
import 'role_guard.dart';

/// Resolves the active [UserEntity] from the global auth state.
///
/// Returns `null` for guests. Use this from repositories, services, and
/// providers that need to know who is signed in without re-reading the
/// auth controller directly.
final Provider<UserEntity?> securityContextProvider = Provider<UserEntity?>(
  (Ref ref) {
    final AuthState auth = ref.watch(authStateProvider);
    return auth.user;
  },
);

/// `true` when the active user is fully authenticated.
final Provider<bool> isAuthenticatedProvider = Provider<bool>((Ref ref) {
  return ref.watch(securityContextProvider) != null;
});

/// `true` when the active user holds [UserRole.admin].
final Provider<bool> isAdminProvider = Provider<bool>((Ref ref) {
  return RoleGuard.hasRole(ref.watch(securityContextProvider), UserRole.admin);
});

/// `true` when the active user holds at least [UserRole.premium].
final Provider<bool> isPremiumProvider = Provider<bool>((Ref ref) {
  return RoleGuard.hasRole(ref.watch(securityContextProvider), UserRole.premium);
});