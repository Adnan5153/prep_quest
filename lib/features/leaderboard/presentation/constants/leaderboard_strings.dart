/// Single home for all leaderboard copy.
///
/// Every user-facing string for the leaderboard feature is declared
/// here so designers can review / localise without touching widget
/// code. Strings follow the same naming convention as the mission /
/// streak features.
class LeaderboardStrings {
  const LeaderboardStrings._();

  // ----- Hub -----
  static const String hubTitle = 'Leaderboards';
  static const String hubSubtitle =
      'See where you stand among friends, classmates and the country.';
  static const String hubActionSeeAll = 'See all';

  // ----- Scope labels -----
  static const String scopeFriends = 'Friends';
  static const String scopeUniversity = 'University';
  static const String scopeNational = 'National';
  static const String scopeWeekly = 'Weekly';
  static const String scopeSeasonal = 'Seasonal';

  // ----- Detail -----
  static const String detailLastUpdated = 'Last updated';
  static const String detailParticipants = 'participants';
  static const String detailYourRank = 'Your rank';
  static const String detailViewFull = 'View full board';
  static const String detailClose = 'Close';

  // ----- Podium -----
  static const String podiumFirst = 'Champion';
  static const String podiumSecond = 'Runner-up';
  static const String podiumThird = 'Third place';

  // ----- Rank tile -----
  static const String rankLevel = 'Lv';
  static const String rankXp = 'XP';
  static const String rankCoins = 'coins';
  static const String rankStreak = 'day streak';
  static const String rankUp = 'up';
  static const String rankDown = 'down';
  static const String rankUnchanged = 'no change';
  static const String rankBadgePremium = 'PRO';

  // ----- Current user card -----
  static const String currentUserHeadline = 'You';
  static const String currentUserRankLabel = 'Current rank';
  static const String currentUserXpLabel = 'XP to next rank';

  // ----- Statistics -----
  static const String statsTitle = 'Your stats';
  static const String statsTotalXp = 'Total XP';
  static const String statsTotalCoins = 'Total coins';
  static const String statsLongestStreak = 'Longest streak';
  static const String statsHighestLevel = 'Highest level';
  static const String statsBadgeCount = 'Badges';

  // ----- Filter -----
  static const String filterTitle = 'Scope';
  static const String filterSubtitle = 'Pick a leaderboard';

  // ----- Sort -----
  static const String sortTitle = 'Sort by';
  static const String sortRank = 'Rank';
  static const String sortXp = 'XP';
  static const String sortCoins = 'Coins';
  static const String sortStreak = 'Streak';
  static const String sortLevel = 'Level';

  // ----- Search -----
  static const String searchHint = 'Search by username or university';

  // ----- States -----
  static const String loadingTitle = 'Loading leaderboard';
  static const String loadingSubtitle = 'One moment…';
  static const String emptyTitle = 'No rankings yet';
  static const String emptySubtitle =
      'Be the first to appear on this board — finish a quiz to get ranked.';
  static const String errorTitle = 'Leaderboard unavailable';
  static const String errorSubtitle =
      'We could not load this leaderboard. Pull to refresh or try again.';
  static const String retry = 'Retry';

  // ----- Progress / position -----
  static const String progressToNext = 'to next rank';
  static const String progressAbove = 'Above you';
  static const String progressBelow = 'Below you';
}