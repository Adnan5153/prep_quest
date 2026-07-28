/// Catalog of streak-bonus tiers.
enum StreakBonusType {
  /// Small XP / coins granted every day the user logs in.
  daily,

  /// Larger grant unlocked at fixed weekly milestones (7, 14, 30 days).
  weekly,

  /// Long-horizon grant for 50 / 100 / 365-day streaks.
  milestone,
}

/// How the user is paying to recover a broken streak.
enum RecoveryMethod {
  /// Pay coins.
  coins,

  /// Use the premium pass — grants a free recovery.
  premium,
}

/// Visual / gameplay status for a single day on the streak calendar.
enum StreakDayStatus {
  /// Day is in the past and was successfully claimed.
  completed,

  /// Day is in the past and was missed.
  missed,

  /// Day is today — claim is eligible.
  today,

  /// Day is in the future — locked.
  future,

  /// Day is locked for another reason (e.g. before the streak began).
  locked,
}