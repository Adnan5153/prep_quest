/// Generic functional result used by the data layer.
///
/// Repositories return a [Result] instead of throwing, so the
/// application/presentation layer can branch on success/failure without
/// an additional try/catch at every call site. Failures are surfaced
/// explicitly via the [Failure] hierarchy from
/// `lib/core/errors/failures.dart`.
library;

import 'package:flutter/foundation.dart';

import '../../core/errors/failures.dart';

@immutable
class Result<T> {
  const Result.success(T value)
      : _value = value,
        _failure = null,
        _isSuccess = true;

  const Result.failure(Failure failure)
      : _value = null,
        _failure = failure,
        _isSuccess = false;

  final T? _value;
  final Failure? _failure;
  final bool _isSuccess;

  bool get isSuccess => _isSuccess;
  bool get isFailure => !_isSuccess;

  T? get valueOrNull => _value;

  Failure? get failureOrNull => _failure;

  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  }) {
    if (_isSuccess) {
      return onSuccess(_value as T);
    }
    return onFailure(_failure!);
  }

  T get value {
    if (_isSuccess) return _value as T;
    throw StateError('Result is a failure: $_failure');
  }
}
