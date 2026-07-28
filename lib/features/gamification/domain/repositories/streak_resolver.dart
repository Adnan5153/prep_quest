import '../entities/streak_day.dart';
import '../entities/streak_state.dart';
import '../entities/user_rewards_state.dart';

/// Resolves "is today eligible for a daily-reward claim?".
///
/// Implementations decide whether the user missed a day, may claim
/// today, or is locked out — without leaking date math into the
/// presentation layer.
abstract class StreakResolver {
  String todayKey({DateTime? now});

  bool isToday(String? lastClaimedIso, {DateTime? now});

  bool isMissed({
    required String? lastClaimedIso,
    required DateTime now,
  });

  int daysSince(String? lastClaimedIso, {DateTime? now});

  bool isClaimable({
    required UserRewardsState state,
    required DateTime now,
  });

  /// Returns the next local midnight timestamp (00:00 of the following day).
  DateTime nextMidnight({DateTime? now});

  /// 1..31 — day-of-month for the supplied [d].
  int dayOfMonth(DateTime d);

  /// True when [day] is strictly after today.
  bool isFuture(DateTime day, {DateTime? now});

  /// Builds a 30-day calendar ending at today, used to render the
  /// streak grid in the calendar sub-screen.
  List<StreakDay> buildLast30Days(StreakState state, {DateTime? now});
}