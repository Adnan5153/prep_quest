import '../entities/streak_day.dart';
import '../entities/streak_state.dart';
import '../enums/streak_enums.dart';
import '../entities/user_rewards_state.dart';
import '../repositories/streak_resolver.dart';

/// Default resolver: compares ISO date keys and decides if a day has
/// been missed by checking calendar gap.
class SystemStreakResolver implements StreakResolver {
  const SystemStreakResolver();

  @override
  String todayKey({DateTime? now}) {
    final DateTime today = now ?? DateTime.now();
    return _format(today);
  }

  @override
  bool isToday(String? lastClaimedIso, {DateTime? now}) {
    if (lastClaimedIso == null || lastClaimedIso.isEmpty) return false;
    final DateTime? parsed = DateTime.tryParse(lastClaimedIso);
    if (parsed == null) return false;
    return _format(parsed) == todayKey(now: now);
  }

  @override
  bool isMissed({
    required String? lastClaimedIso,
    required DateTime now,
  }) {
    if (lastClaimedIso == null || lastClaimedIso.isEmpty) return false;
    final DateTime? parsed = DateTime.tryParse(lastClaimedIso);
    if (parsed == null) return false;
    final int gap = now.difference(DateTime(parsed.year, parsed.month, parsed.day)).inDays;
    return gap > 1;
  }

  @override
  int daysSince(String? lastClaimedIso, {DateTime? now}) {
    if (lastClaimedIso == null || lastClaimedIso.isEmpty) return 0;
    final DateTime? parsed = DateTime.tryParse(lastClaimedIso);
    if (parsed == null) return 0;
    final DateTime today = now ?? DateTime.now();
    final int days = today.difference(
      DateTime(parsed.year, parsed.month, parsed.day),
    ).inDays;
    return days < 0 ? 0 : days;
  }

  @override
  bool isClaimable({
    required UserRewardsState state,
    required DateTime now,
  }) {
    if (isToday(state.streak.lastClaimedAtIso, now: now)) return false;
    return true;
  }

  @override
  DateTime nextMidnight({DateTime? now}) {
    final DateTime today = now ?? DateTime.now();
    final DateTime tomorrow = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1));
    return tomorrow;
  }

  @override
  int dayOfMonth(DateTime d) => d.day;

  @override
  bool isFuture(DateTime day, {DateTime? now}) {
    final DateTime today = now ?? DateTime.now();
    final DateTime a = DateTime(day.year, day.month, day.day);
    final DateTime b = DateTime(today.year, today.month, today.day);
    return a.isAfter(b);
  }

  @override
  List<StreakDay> buildLast30Days(StreakState state, {DateTime? now}) {
    final DateTime today = now ?? DateTime.now();
    final DateTime start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 29));
    final DateTime? lastClaimed = state.lastClaimedAtIso.isEmpty
        ? null
        : DateTime.tryParse(state.lastClaimedAtIso);

    final List<StreakDay> days = <StreakDay>[];
    for (int i = 0; i < 30; i++) {
      final DateTime d = start.add(Duration(days: i));
      StreakDayStatus s;
      if (d.isAfter(DateTime(today.year, today.month, today.day))) {
        s = StreakDayStatus.future;
      } else if (d.year == today.year &&
          d.month == today.month &&
          d.day == today.day) {
        s = StreakDayStatus.today;
      } else if (lastClaimed != null &&
          lastClaimed.year == d.year &&
          lastClaimed.month == d.month &&
          lastClaimed.day == d.day) {
        s = StreakDayStatus.completed;
      } else if (state.currentDays > 0 &&
          d.isAfter(
            DateTime(today.year, today.month, today.day)
                .subtract(Duration(days: state.currentDays)),
          )) {
        // Inside the current streak window but not the most recent
        // claim — treat as completed.
        s = StreakDayStatus.completed;
      } else {
        s = StreakDayStatus.missed;
      }
      days.add(StreakDay(date: d, status: s));
    }
    return List<StreakDay>.unmodifiable(days);
  }

  String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}