import 'package:flutter/foundation.dart';

/// Base domain failure.
///
/// Concrete failures describe *why* an operation failed. They are
/// produced by the data layer and consumed by the application/
/// presentation layer so screens can render a user-friendly message
/// without leaking transport details.
@immutable
abstract class Failure {
  const Failure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

/// Network is unreachable or timed out.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause});
}

/// Server responded with a non-success status or unexpected payload.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, super.cause});

  final int? statusCode;
}

/// Firebase / auth provider rejected the credentials or session.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {this.code, super.cause});

  /// Stable, machine-readable code (e.g. `user-not-found`,
  /// `wrong-password`, `email-already-in-use`).
  final String? code;
}

/// Provided input was invalid (validation, missing fields, etc.).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors = const <String, String>{}, super.cause});

  final Map<String, String> fieldErrors;
}

/// Caller was not allowed to perform the operation.
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {super.cause});
}

/// Local cache or session is corrupt / unavailable.
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.cause});
}

/// Catch-all failure when the exact reason is unknown.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.cause});
}

/// A reward with the same `{source}:{sourceId}` key was already
/// applied to the user's coin ledger. Returned by [CoinService.grant]
/// when a duplicate submission is detected (replay, retry, or
/// double-fire from a synchronously-mounted listener).
class DuplicateRewardFailure extends Failure {
  const DuplicateRewardFailure(super.message, {required this.sourceKey, super.cause});

  final String sourceKey;
}

/// The user attempted to spend more coins than their current balance.
/// Returned by [CoinService.spend] when the resulting balance would
/// go below zero. The coin economy never produces a negative balance.
class InsufficientCoinsFailure extends Failure {
  const InsufficientCoinsFailure(super.message, {required this.shortfall, super.cause});

  /// Positive integer — how many coins the user was missing.
  final int shortfall;
}

/// A mission progress update was rejected because the same
/// `{uid}:{missionId}:{sessionId}` triple was already applied. Used
/// by [MissionProgressService.recordAttempt] to dedup replays.
class DuplicateMissionAttemptFailure extends Failure {
  const DuplicateMissionAttemptFailure(super.message, {required this.sessionKey, super.cause});

  final String sessionKey;
}

/// A mission completion was rejected because the user is currently
/// in a guest session and the write would have failed Firestore
/// authorization. The local mirror still updates; the failure is
/// surfaced so the controller can route the replay on login.
class GuestMissionWriteFailure extends Failure {
  const GuestMissionWriteFailure(super.message, {super.cause});
}