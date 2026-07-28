import '../utils/date_utils.dart';

/// Convenience extension on [DateTime] and `int` (seconds-since-epoch)
/// that delegates to [DateUtils].
extension DurationFormatting on int {
  /// Formats this integer (interpreted as a duration in seconds) using
  /// [DateUtils.formatDuration]. Example: `(87).asDuration() == '1m 27s'`.
  String asDuration() => DateUtils.formatDuration(this);

  /// Formats seconds as `MM:SS` clock string.
  String asClock() => DateUtils.secondsToClock(this);
}

extension NullableDateFormatting on DateTime? {
  /// ISO 8601 string for nullable dates; null-safe.
  String? toIsoOrNull() => this?.toIso8601String();
}
