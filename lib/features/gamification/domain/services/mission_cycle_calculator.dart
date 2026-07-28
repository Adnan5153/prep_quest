import '../enums/mission_enums.dart';

/// Pure functions for mission-reset scheduling.
///
/// All inputs are local-time `DateTime`s and outputs are local-time
/// boundaries. The calculator never touches the wall clock directly —
/// callers pass `now` so tests stay deterministic.
class MissionCycleCalculator {
  const MissionCycleCalculator();

  /// Returns the next reset boundary for the given cadence after
  /// `from`. Returns the same instant when `from` already matches a
  /// boundary (e.g. midnight local) so the caller can advance one
  /// step.
  DateTime nextResetAfter(MissionCadence cadence, {required DateTime from}) {
    switch (cadence) {
      case MissionCadence.daily:
        return _nextMidnight(from);
      case MissionCadence.weekly:
        return _nextWeekStart(from);
      case MissionCadence.monthly:
        return _nextMonthStart(from);
    }
  }

  DateTime _nextMidnight(DateTime from) {
    final DateTime midnight = DateTime(from.year, from.month, from.day);
    if (midnight.isAfter(from)) return midnight;
    return midnight.add(const Duration(days: 1));
  }

  DateTime _nextWeekStart(DateTime from) {
    final DateTime today = DateTime(from.year, from.month, from.day);
    final int daysUntilMonday = (DateTime.monday - today.weekday) % 7;
    if (daysUntilMonday == 0 && !today.isAfter(from)) return today;
    return today.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
  }

  DateTime _nextMonthStart(DateTime from) {
    final DateTime monthStart = DateTime(from.year, from.month);
    if (monthStart.isAfter(from)) return monthStart;
    return DateTime(from.year, from.month + 1);
  }

  /// Seconds remaining until the next reset for `cadence`.
  int secondsUntilReset(MissionCadence cadence, {required DateTime now}) {
    return nextResetAfter(cadence, from: now)
        .difference(now)
        .inSeconds
        .clamp(0, 1 << 31);
  }

  /// True when the given expiration ISO timestamp has passed relative
  /// to `now`.
  bool hasExpired(String? expiresAtIso, {required DateTime now}) {
    if (expiresAtIso == null || expiresAtIso.isEmpty) return false;
    final DateTime? parsed = DateTime.tryParse(expiresAtIso);
    if (parsed == null) return false;
    return !parsed.isAfter(now);
  }
}