/// Five supported leaderboard scopes.
enum LeaderboardScope {
  friends,
  university,
  national,
  weekly,
  seasonal,
}

/// Sort order applied to a leaderboard list.
enum LeaderboardSort {
  rank,
  xp,
  coins,
  streak,
  level,
}

/// Direction of a single user's rank shift since the previous fetch.
enum RankChange {
  up,
  down,
  unchanged,
}