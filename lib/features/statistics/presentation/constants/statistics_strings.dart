class StatisticsStrings {
  const StatisticsStrings._();

  static const String screenTitle = 'Your Statistics';
  static const String loading = 'Crunching your stats…';
  static const String failedToLoad = 'We could not load your statistics.';
  static const String retryAction = 'Try Again';
  static const String emptyTitle = 'No activity yet';
  static const String emptySubtitle =
      'Start a quiz, read a lesson, or complete a daily challenge to see your progress here.';

  static const String xpSectionTitle = 'Experience Points';
  static const String xpTotal = 'Total XP';
  static const String xpToday = 'Today';
  static const String xpWeekly = 'This Week';
  static const String xpMonthly = 'This Month';
  static const String xpGrowthChart = 'XP Growth';
  static const String xpLevel = 'Level';
  static const String xpToNext = 'XP to next level';

  static const String accuracySectionTitle = 'Accuracy Analytics';
  static const String accuracyOverall = 'Overall Accuracy';
  static const String accuracySubject = 'By Subject';
  static const String accuracyTopic = 'By Topic';
  static const String accuracyDailyTrend = 'Daily Trend';
  static const String accuracyWeeklyTrend = 'Weekly Trend';
  static const String correctLabel = 'Correct';
  static const String wrongLabel = 'Wrong';
  static const String skippedLabel = 'Skipped';

  static const String studySectionTitle = 'Study Time';
  static const String studyToday = 'Today';
  static const String studyWeek = 'This Week';
  static const String studyMonth = 'This Month';
  static const String studyDailyAverage = 'Daily Average';
  static const String studyStreak = 'Streak';
  static const String studyHeatmap = 'Study Heatmap';
  static const String studyWeeklyActivity = 'Weekly Activity';
  static const String studyMonthlyActivity = 'Monthly Activity';

  static const String weakSectionTitle = 'Subjects Needing Attention';
  static const String weakPriorityIndicator = 'Priority';
  static const String weakRecommendedRevision = 'Recommended Revision';
  static const String weakMostIncorrect = 'Most Incorrect Questions';

  static const String strongSectionTitle = 'Subjects You Mastered';
  static const String strongMasteryIndicator = 'Mastery';
  static const String strongAchievement = 'Achievement Unlocked';

  static const String chartsSectionTitle = 'Performance Charts';
  static const String chartLine = 'Line';
  static const String chartBar = 'Bar';
  static const String chartPie = 'Distribution';
  static const String chartRing = 'Progress Rings';
  static const String chartWeekly = 'Weekly Activity';
  static const String chartMonthly = 'Monthly Activity';

  static String accuracyPercent(int percent) => '$percent%';
  static String xpValue(int xp) => '$xp XP';
}