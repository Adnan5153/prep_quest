/// All user-facing copy for the Daily / Weekly / Monthly missions feature.
class MissionStrings {
  const MissionStrings._();

  // ----- Hub screen ----------------------------------------------------------
  static const String hubTitle = 'Missions';
  static const String hubSubtitle =
      'Pick a cycle and chase the rewards waiting inside.';

  static const String hubDailyTitle = 'Daily missions';
  static const String hubDailySubtitle =
      'Short-term missions that reset every day.';

  static const String hubWeeklyTitle = 'Weekly missions';
  static const String hubWeeklySubtitle =
      'Medium-term missions that reset every week.';

  static const String hubMonthlyTitle = 'Monthly missions';
  static const String hubMonthlySubtitle =
      'Long-term missions with bigger rewards.';

  static const String hubProgressTemplate = '%d / %d complete';
  static const String hubRewardPreviewTemplate = '+%d XP · %d coins';

  // ----- Per-cadence screens -------------------------------------------------
  static const String dailyScreenTitle = 'Daily missions';
  static const String weeklyScreenTitle = 'Weekly missions';
  static const String monthlyScreenTitle = 'Monthly missions';

  // ----- Legacy / section copy (kept for reuse) ------------------------------
  static const String sectionDaily = 'Today';
  static const String sectionWeekly = 'This week';
  static const String sectionMonthly = 'This month';
  static const String sectionResetTemplate = 'Resets in %s';
  static const String sectionCountTemplate = '%d missions';

  static const String statusLocked = 'Locked';
  static const String statusAvailable = 'Ready';
  static const String statusInProgress = 'In progress';
  static const String statusCompleted = 'Completed';
  static const String statusClaimed = 'Claimed';
  static const String statusExpired = 'Expired';

  static const String progressTemplate = '%d / %d';
  static const String progressPercentTemplate = '%d%%';
  static const String timerFallback = '—';
  static const String daysTemplate = '%dd %02d:%02d:%02d';
  static const String timeTemplate = '%02d:%02d:%02d';

  static const String claimButton = 'Claim';
  static const String claimedLabel = 'Claimed';
  static const String lockedLabel = 'Locked';

  static const String statsTotalTemplate = '%d of %d complete';
  static const String statsDailyTemplate = '%d of %d today';
  static const String statsWeeklyTemplate = '%d of %d this week';
  static const String statsMonthlyTemplate = '%d of %d this month';

  static const String rewardXpTemplate = '+%d XP';
  static const String rewardCoinTemplate = '+%d Coins';
  static const String rewardEnergyTemplate = '+%d Energy';
  static const String rewardBadgeLabel = 'Badge';
  static const String rewardChestLabel = 'Chest';

  static const String emptyTitle = 'No missions right now';
  static const String emptySubtitle =
      'New missions will appear when this cycle rolls over.';

  static const String errorTitle = 'Missions are unavailable';
  static const String errorRetry = 'Retry';

  static const String loadingLabel = 'Loading missions…';

  static const String completedDialogTitle = 'Mission complete!';
  static const String completedDialogXpTemplate = '+%d XP';
  static const String completedDialogCoinsTemplate = '+%d Coins';
  static const String completedDialogBadgeTemplate = 'Badge: %s';
  static const String completedDialogContinue = 'Awesome';
}