/// Canonical week / season identifier helper for Phase 44 leaderboards.
///
/// Weekly rows are partitioned by ISO week (`2026-W31`). Seasonal
/// rows are partitioned by calendar quarter (`2026-Q3`). Lifetime
/// scopes (national, university, friends) use the literal `lifetime`.
/// The helper is pure and injectable (all methods accept [now]) so
/// unit tests never depend on the wall clock.
class LeaderboardSeason {
  const LeaderboardSeason._();

  static const String lifetime = 'lifetime';

  static String currentWeekId([DateTime? now]) {
    final DateTime utc = (now ?? DateTime.now()).toUtc();
    final DateTime thursday = utc.add(Duration(days: 4 - utc.weekday));
    final DateTime firstThursday = DateTime.utc(thursday.year, 1, 4);
    final int week = 1 +
        (thursday.difference(
                  firstThursday.add(
                    Duration(days: 4 - firstThursday.weekday),
                  ),
                ).inDays ~/
            7);
    return '${thursday.year}-W${week.toString().padLeft(2, '0')}';
  }

  static String currentSeasonId([DateTime? now]) {
    final DateTime utc = (now ?? DateTime.now()).toUtc();
    final int quarter = ((utc.month - 1) ~/ 3) + 1;
    return '${utc.year}-Q$quarter';
  }
}