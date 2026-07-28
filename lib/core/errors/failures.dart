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