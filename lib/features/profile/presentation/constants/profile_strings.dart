/// All user-visible strings for the Profile feature.
///
/// Centralising copy keeps the dark/light themes and future
/// localisation simple — every screen pulls from this registry.
class ProfileStrings {
  const ProfileStrings._();

  // ----- Screen -----
  static const String screenTitle = 'Profile';
  static const String screenSubtitle =
      'Your journey, achievements, and study stats at a glance.';

  // ----- Quick actions -----
  static const String resumeAction = 'Resume';
  static const String mockTestAction = 'Mock Test';
  static const String guidebookAction = 'Guidebook';
  static const String leaderboardAction = 'Leaderboard';
  static const String aiTutorAction = 'AI Tutor';
  static const String rewardsAction = 'Rewards';
  static const String missionsAction = 'Missions';
  static const String streakAction = 'Streak';
  static const String searchAction = 'Search';
  static const String bookmarksAction = 'Bookmarks';
  static const String notesAction = 'Notes';

  /// Stable identifiers for the quick-action tiles. Keep these in
  /// sync with the [UserProfile.quickActions] list and the switch in
  /// `profile_screen.dart`.
  static const String resumeActionId = 'resume';
  static const String mockTestActionId = 'mock_test';
  static const String guidebookActionId = 'guidebook';
  static const String leaderboardActionId = 'leaderboard';
  static const String aiTutorActionId = 'ai_tutor';
  static const String rewardsActionId = 'rewards';
  static const String missionsActionId = 'missions';
  static const String streakActionId = 'streak';
  static const String searchActionId = 'search';
  static const String bookmarksActionId = 'bookmarks';
  static const String notesActionId = 'notes';

  // ----- Sections -----
  static const String progressionSectionTitle = 'Progression';
  static const String goalSectionTitle = 'Your Goal';
  static const String languageSectionTitle = 'Language';
  static const String energySectionTitle = 'Energy';
  static const String rankSectionTitle = 'Current Rank';
  static const String achievementsSectionTitle = 'Achievements';
  static const String badgesSectionTitle = 'Badges';
  static const String statsSectionTitle = 'Study Stats';
  static const String quickActionsSectionTitle = 'Quick Actions';

  // ----- Empty states -----
  static const String noAchievements = 'No achievements yet — keep going!';
  static const String noBadges = 'Badges unlock as you hit milestones.';

  // ----- Errors / feedback -----
  static const String loadingProfile = 'Loading your profile…';
  static const String retry = 'Retry';

  // ----- Generic labels -----
  static const String xpLabel = 'XP';
  static const String levelLabel = 'Level';
  static const String coinsLabel = 'Coins';
  static const String energyLabel = 'Energy';
  static const String streakLabel = 'Streak';
  static const String accuracyLabel = 'Accuracy';
  static const String studyTimeLabel = 'Study Time';
  static const String quizzesLabel = 'Quizzes';
  static const String questionsLabel = 'Questions';
  static const String correctLabel = 'Correct';
  static const String longestStreakLabel = 'Longest Streak';
  static const String currentStreakLabel = 'Current Streak';
  static const String lockedLabel = 'Locked';
  static const String earnedLabel = 'Earned';

  // ----- Misc -----
  static const String editAction = 'Edit';
  static const String viewAllAction = 'View all';
  static const String dailyStreakSuffix = 'days';
  static const String profileCompletedLabel = 'Profile completed';
  static const String profileIncompleteLabel = 'Finish setting up your profile';
  static const String universityLabel = 'University';
  static const String districtLabel = 'District';
  static const String bioLabel = 'Bio';
}