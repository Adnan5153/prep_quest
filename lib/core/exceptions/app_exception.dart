import 'package:flutter/foundation.dart';

/// Base exception type thrown by the data layer when something
/// unrecoverable happens. Callers are expected to translate these
/// into [Failure]s before crossing into the application/presentation
/// layer.
@immutable
class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stack});

  final String message;
  final Object? cause;
  final StackTrace? stack;

  @override
  String toString() => '$runtimeType: $message';
}

/// Wraps a transport / provider-specific exception (e.g. Firebase
/// `FirebaseAuthException`).
class RemoteException extends AppException {
  const RemoteException(super.message, {this.code, super.cause, super.stack});

  final String? code;
}

/// Local persistence failed (Hive, secure storage, file I/O).
class LocalStorageException extends AppException {
  const LocalStorageException(super.message, {super.cause, super.stack});
}

/// Input failed validation before being sent to the remote.
class InvalidInputException extends AppException {
  const InvalidInputException(super.message, {super.cause, super.stack});
}