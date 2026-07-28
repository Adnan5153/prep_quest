/// All user-visible strings for the Streak feature.
class StreakStrings {
  const StreakStrings._();

  // ----- Hub -----
  static const String hubTitle = 'Streak';
  static const String hubSubtitle =
      'Keep your learning streak alive to earn bonus XP and coins every day.';

  // ----- Counter -----
  static const String currentStreakLabel = 'Current streak';
  static const String bestStreakLabel = 'Best streak';
  static const String shieldsLabel = 'Streak freezes';
  static const String todayStatusClaimed = 'Claimed today';
  static const String todayStatusPending = 'Claim today';
  static const String atRiskBadge = 'At risk';

  // ----- Bonus section -----
  static const String bonusSectionTitle = 'Streak Bonuses';
  static const String bonusSectionSubtitle =
      'Earn rewards at every daily / weekly / monthly milestone.';
  static const String bonusDailyTag = 'Daily';
  static const String bonusWeeklyTag = 'Weekly';
  static const String bonusMilestoneTag = 'Milestone';
  static const String bonusDayTemplate = 'Day %d';
  static const String bonusClaimedLabel = 'Claimed';
  static const String bonusLockedLabel = 'Locked';
  static const String bonusRewardTemplate = '%d XP · %d coins';

  // ----- Daily login banner -----
  static const String bannerTitle = 'Daily login';
  static const String bannerSubtitle = 'Tap to claim today\'s streak reward';
  static const String bannerAction = 'Claim';
  static const String bannerActionClaimed = 'Claimed';
  static const String bannerRecoverCta = 'Recover streak';

  // ----- Calendar -----
  static const String calendarTitle = 'Streak calendar';
  static const String calendarSubtitle =
      'Your last 30 days — green is claimed, red is missed.';
  static const String calendarLegendCompleted = 'Claimed';
  static const String calendarLegendMissed = 'Missed';
  static const String calendarLegendToday = 'Today';
  static const String calendarLegendFuture = 'Upcoming';

  // ----- Recovery -----
  static const String recoveryTitle = 'Recover streak';
  static const String recoverySubtitle =
      'You missed yesterday — pick how you\'d like to restart.';
  static const String recoveryCoinsTitle = 'Use 25 coins';
  static const String recoveryCoinsSubtitle =
      'Cheapest path back to a fresh streak.';
  static const String recoveryPremiumTitle = 'Premium recovery';
  static const String recoveryPremiumSubtitle =
      'Free recovery + 1 bonus streak freeze.';
  static const String recoveryConfirm = 'Recover';
  static const String recoveryCancel = 'Cancel';

  // ----- Errors / feedback -----
  static const String loadingStreak = 'Loading your streak…';
  static const String retry = 'Retry';
  static const String emptyBonus = 'No streak bonuses available yet.';
}