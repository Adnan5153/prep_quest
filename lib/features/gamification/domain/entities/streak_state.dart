import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';
import '../enums/streak_enums.dart';
import 'streak_day.dart';

/// User's login-streak state.
@immutable
class StreakState {
  const StreakState({
    required this.currentDays,
    required this.bestDays,
    required this.lastClaimedAtIso,
    this.shieldCharges = 0,
    this.recoveryUsedThisWeek = 0,
    this.nextMilestoneDays = 7,
    this.calendarDays = const <StreakDay>[],
    this.status = DailyRewardStatus.future,
  });

  final int currentDays;
  final int bestDays;
  final String lastClaimedAtIso;
  final int shieldCharges;
  final int recoveryUsedThisWeek;
  final int nextMilestoneDays;
  final List<StreakDay> calendarDays;
  final DailyRewardStatus status;

  /// True when the user already logged in today — no re-claim.
  bool isTodayClaimed(DateTime now) {
    if (lastClaimedAtIso.isEmpty) return false;
    final DateTime? parsed = DateTime.tryParse(lastClaimedAtIso);
    if (parsed == null) return false;
    return parsed.year == now.year &&
        parsed.month == now.month &&
        parsed.day == now.day;
  }

  /// True when the streak is at risk: still alive but tomorrow is a
  /// new day that must be claimed or the chain breaks.
  bool get isAtRisk => currentDays > 0 && !_calendarAlreadyClaimedToday();

  bool _calendarAlreadyClaimedToday() {
    for (final StreakDay day in calendarDays) {
      if (day.status == StreakDayStatus.today) return true;
    }
    return false;
  }

  StreakState copyWith({
    int? currentDays,
    int? bestDays,
    String? lastClaimedAtIso,
    int? shieldCharges,
    int? recoveryUsedThisWeek,
    int? nextMilestoneDays,
    List<StreakDay>? calendarDays,
    DailyRewardStatus? status,
  }) {
    return StreakState(
      currentDays: currentDays ?? this.currentDays,
      bestDays: bestDays ?? this.bestDays,
      lastClaimedAtIso: lastClaimedAtIso ?? this.lastClaimedAtIso,
      shieldCharges: shieldCharges ?? this.shieldCharges,
      recoveryUsedThisWeek:
          recoveryUsedThisWeek ?? this.recoveryUsedThisWeek,
      nextMilestoneDays: nextMilestoneDays ?? this.nextMilestoneDays,
      calendarDays: calendarDays ?? this.calendarDays,
      status: status ?? this.status,
    );
  }
}