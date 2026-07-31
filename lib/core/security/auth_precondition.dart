import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/enums/user_role.dart';
import 'role_guard.dart';
import 'security_context.dart';

/// Helper for repositories that need to enforce an auth precondition
/// before delegating to the data source. Call [assertAuthenticated],
/// [assertAdmin], or [assertPremium] at the top of mutating methods;
/// failure raises [AuthorizationException] which the existing
/// `ErrorHandler.map` translates to [AuthorizationFailure].
///
/// Composition over mixin: repositories hold an [AuthGuard] instance
/// instead of mixing the helpers in. The guard captures the Riverpod
/// container once at construction so per-call cost is a single
/// `ref.read`.
///
/// Usage:
///
/// ```dart
/// class MyRepository {
///   MyRepository(Ref ref) : _guard = AuthGuard(ref);
///
///   final AuthGuard _guard;
///
///   Future<void> save() {
///     _guard.assertAuthenticated();
///   }
/// }
/// ```
class AuthGuard {
  AuthGuard(this._ref);

  final Ref _ref;

  /// Throws [AuthorizationException] if the caller is not signed in.
  void assertAuthenticated() {
    RoleGuard.assertAuthorized(
      SecurityAction.writeOwn,
      _ref.read(securityContextProvider),
    );
  }

  /// Throws [AuthorizationException] if the caller is not an admin.
  void assertAdmin() {
    RoleGuard.assertAuthorized(
      SecurityAction.mutateAdmin,
      _ref.read(securityContextProvider),
    );
  }

  /// Throws [AuthorizationException] if the caller is not at least a
  /// [UserRole.premium] subscriber.
  void assertPremium() {
    RoleGuard.assertAuthorized(
      SecurityAction.mutatePremium,
      _ref.read(securityContextProvider),
    );
  }

  /// Throws [AuthorizationException] if the active user does not own
  /// [userId]. Use for subcollection writes where the resource is
  /// keyed by the owner uid.
  void assertOwnership(String userId) {
    RoleGuard.assertOwnership(
      action: SecurityAction.writeOwn,
      user: _ref.read(securityContextProvider),
      userId: userId,
    );
  }
}