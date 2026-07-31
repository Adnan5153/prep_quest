import '../../features/authentication/domain/entities/user_entity.dart';
import '../../shared/enums/user_role.dart';
import '../exceptions/app_exception.dart';

/// Coarse-grained security action a caller wants to perform.
///
/// Repositories map their mutating methods to a [SecurityAction]; the
/// guard then resolves the user + role. Centralising this keeps
/// permission logic out of widgets and individual repositories.
enum SecurityAction {
  /// Reading the current user's own data (e.g. user profile).
  readOwn,

  /// Mutating the current user's own data (e.g. bookmarks, notes).
  writeOwn,

  /// Reading public content (categories, lessons, leaderboard).
  readPublic,

  /// Mutating admin-managed content (categories, questions, lessons).
  mutateAdmin,

  /// Accessing premium-restricted content.
  mutatePremium,
}

/// Thrown by [RoleGuard.assertAuthorized] when the active user is
/// not allowed to perform the requested [SecurityAction]. Translated
/// to [AuthorizationFailure] by [ErrorHandler.map].
class AuthorizationException extends AppException {
  const AuthorizationException(
    super.message, {
    required this.action,
    required this.requiredRole,
    this.actualRole,
    super.cause,
  });

  /// The action that was attempted.
  final SecurityAction action;

  /// The minimum role required.
  final UserRole requiredRole;

  /// The role the caller actually had (or `null` for guest).
  final UserRole? actualRole;
}

/// Centralised role / authorization helpers.
///
/// Repositories call [assertAuthorized] at the top of mutating methods
/// instead of re-implementing the same role checks. The guard throws
/// [AuthorizationException] which [ErrorHandler.map] translates to
/// [AuthorizationFailure] — the rest of the app never has to know the
/// internal exception vocabulary.
class RoleGuard {
  const RoleGuard._();

  /// Returns `true` when [user] holds at least the privilege of
  /// [required]. `admin` always wins. `premium` clears `premium`-only
  /// checks but not `admin` checks.
  static bool hasRole(UserEntity? user, UserRole required) {
    if (user == null) return false;
    final UserRole actual = user.role;
    if (required == UserRole.free) return true;
    if (required == UserRole.premium) {
      return actual == UserRole.premium || actual == UserRole.admin;
    }
    return actual == UserRole.admin;
  }

  /// Resolves the minimum role required for [action].
  static UserRole requiredRole(SecurityAction action) {
    switch (action) {
      case SecurityAction.readOwn:
      case SecurityAction.writeOwn:
      case SecurityAction.readPublic:
        return UserRole.free;
      case SecurityAction.mutateAdmin:
        return UserRole.admin;
      case SecurityAction.mutatePremium:
        return UserRole.premium;
    }
  }

  /// Throws [AuthorizationException] when [user] is not allowed to
  /// perform [action].
  static void assertAuthorized(SecurityAction action, UserEntity? user) {
    final UserRole required = requiredRole(action);
    if (hasRole(user, required)) return;
    if (user == null) {
      throw AuthorizationException(
        'Authentication required for ${action.name}.',
        action: action,
        requiredRole: required,
      );
    }
    throw AuthorizationException(
      'Role ${required.name} required for ${action.name}; '
      'current role is ${user.role.name}.',
      action: action,
      requiredRole: required,
      actualRole: user.role,
    );
  }

  /// Convenience helper for ownership + role checks. Verifies the
  /// caller is signed in AND that [userId] matches the signed-in uid.
  static void assertOwnership({
    required SecurityAction action,
    required UserEntity? user,
    required String userId,
  }) {
    if (user == null || user.id.isEmpty || user.id != userId) {
      throw AuthorizationException(
        'Caller does not own ${action.name} resource ($userId).',
        action: action,
        requiredRole: requiredRole(action),
        actualRole: user?.role,
      );
    }
    assertAuthorized(action, user);
  }
}