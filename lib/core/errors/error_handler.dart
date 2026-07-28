import 'dart:async';

import '../exceptions/app_exception.dart';
import 'failures.dart';

/// Centralised translation between exception types and user-facing
/// [Failure]s. Every data-source / repository funnel goes through
/// here so the rest of the app sees a stable failure vocabulary.
class ErrorHandler {
  const ErrorHandler._();

  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;
    if (error is RemoteException) {
      return AuthenticationFailure(
        error.message,
        code: error.code,
        cause: error.cause,
      );
    }
    if (error is InvalidInputException) {
      return ValidationFailure(error.message, cause: error.cause);
    }
    if (error is LocalStorageException) {
      return CacheFailure(error.message, cause: error.cause);
    }
    if (error is TimeoutException) {
      return const NetworkFailure(
        'The request timed out. Please check your connection and try again.',
      );
    }
    return UnknownFailure(
      error.toString(),
      cause: error,
    );
  }
}