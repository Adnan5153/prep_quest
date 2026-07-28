/// Static, typed copy for the Quiz Results feature.
class QuizResultsStrings {
  const QuizResultsStrings._();

  // ----- Top-level screen copy -----
  static const String screenTitle = 'Quiz Results';
  static const String loadingResults = 'Calculating your score…';
  static const String failedToLoad = 'Could not load your results.';

  // ----- Score hero card -----
  static const String passedHeadline = 'You passed!';
  static const String failedHeadline = 'Almost there';
  static const String scoreLabel = 'Score';

  // ----- Statistics tiles -----
  static const String correctAnswers = 'Correct';
  static const String wrongAnswers = 'Wrong';
  static const String skippedAnswers = 'Skipped';
  static const String timeSpent = 'Time Spent';

  // ----- Analysis cards -----
  static const String accuracyCardTitle = 'Accuracy';
  static const String timeAnalysisCardTitle = 'Time Analysis';
  static const String performanceSummaryTitle = 'Performance Summary';
  static const String rankProgressTitle = 'Rank Progress';
  static const String xpRewardTitle = 'Experience Gained';
  static const String coinRewardTitle = 'Coins Earned';

  // ----- Topic cards -----
  static const String weakTopicsTitle = 'Topics to Review';
  static const String strongTopicsTitle = 'Topics You Crushed';
  static const String weakTopicsViewAll = 'View all';

  // ----- Action buttons -----
  static const String retryAction = 'Retry Quiz';
  static const String reviewAction = 'Review Answers';
  static const String continueLearningAction = 'Continue Learning';
  static const String shareAction = 'Share Result';
  static const String backToMap = 'Back to Map';

  // ----- Sub-screens / dialogs -----
  static const String weakTopicsScreenTitle = 'All Topics to Review';
  static const String performanceBreakdownTitle = 'Performance Breakdown';
  static const String shareCopied = 'Result copied to clipboard';
  static const String shareCopy = 'Copy to clipboard';

  static String motivational(int percent) {
    if (percent >= 95) return 'Flawless victory!';
    if (percent >= 80) return 'Outstanding!';
    if (percent >= 60) return 'Solid work.';
    if (percent >= 40) return 'Keep going.';
    return 'Practice makes perfect.';
  }
}
