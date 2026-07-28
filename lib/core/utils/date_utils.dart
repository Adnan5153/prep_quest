/// Pure formatters for durations, clock strings, and ISO timestamps.
///
/// Centralised so every feature can format durations consistently.
class DateUtils {
  const DateUtils._();

  /// Formats a duration in seconds as `H h M m S s` (e.g. `1m 23s`,
  /// `12s`, `2h 14m`). Omits zero leading units.
  static String formatDuration(int seconds) {
    final int total = seconds < 0 ? 0 : seconds;
    final int hours = total ~/ 3600;
    final int minutes = (total % 3600) ~/ 60;
    final int remaining = total % 60;
    final List<String> parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (remaining > 0 || parts.isEmpty) parts.add('${remaining}s');
    return parts.join(' ');
  }

  /// Compact minute formatter used for study-time displays
  /// (e.g. `45 min`, `2h 10m`).
  static String formatStudyMinutes(int minutes) {
    final int total = minutes < 0 ? 0 : minutes;
    if (total >= 60) {
      final int h = total ~/ 60;
      final int m = total % 60;
      return m == 0 ? '${h}h' : '${h}h ${m}m';
    }
    return '${total}m';
  }

  /// Formats seconds as `MM:SS` for live timers (e.g. `01:23`, `00:45`).
  static String secondsToClock(int seconds) {
    final int total = seconds < 0 ? 0 : seconds;
    final int m = total ~/ 60;
    final int s = total % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Returns null if [input] is null/empty/invalid; otherwise parsed date.
  static DateTime? parseIsoOrNull(String? input) {
    if (input == null || input.isEmpty) return null;
    return DateTime.tryParse(input);
  }
}
