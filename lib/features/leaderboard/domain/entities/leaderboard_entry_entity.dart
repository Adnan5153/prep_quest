import 'package:flutter/foundation.dart';

import '../enums/leaderboard_enums.dart';

/// One row in a leaderboard list.
@immutable
class LeaderboardEntryEntity {
  const LeaderboardEntryEntity({
    required this.userId,
    required this.rank,
    required this.previousRank,
    required this.username,
    required this.university,
    required this.avatarUrl,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streakDays,
    required this.badges,
    required this.isCurrentUser,
    required this.isPremium,
    this.accuracyPercent = 0,
    this.completedCategories = 0,
    this.completedMissions = 0,
    this.score = 0,
    this.seasonId = 'lifetime',
  });

  final String userId;
  final int rank;
  final int previousRank;
  final String username;
  final String university;
  final String avatarUrl;
  final int level;
  final int xp;
  final int coins;
  final int streakDays;
  final List<String> badges;
  final bool isCurrentUser;
  final bool isPremium;

  /// 0-100 lifetime accuracy. Sourced from
  /// `UserStatisticsEntity.accuracyPercent` by Phase 44.
  final int accuracyPercent;

  /// Count of categories with `bestScore >= 60`.
  final int completedCategories;

  /// Count of missions in `completed | perfect` status.
  final int completedMissions;

  /// Composite ranking score (see
  /// [LeaderboardRankingEntity.score]). Surfaced for sort-by-score
  /// views and admin tooling; the UI defaults to the positional
  /// `rank` ordering.
  final int score;

  /// Season partition the row belongs to (`lifetime` / weekly id /
  /// seasonal id).
  final String seasonId;

  RankChange get rankChange {
    if (previousRank == 0 || previousRank == rank) {
      return RankChange.unchanged;
    }
    return previousRank > rank ? RankChange.up : RankChange.down;
  }

  int get rankDelta => previousRank == 0 ? 0 : previousRank - rank;

  LeaderboardEntryEntity copyWith({
    String? userId,
    int? rank,
    int? previousRank,
    String? username,
    String? university,
    String? avatarUrl,
    int? level,
    int? xp,
    int? coins,
    int? streakDays,
    List<String>? badges,
    bool? isCurrentUser,
    bool? isPremium,
    int? accuracyPercent,
    int? completedCategories,
    int? completedMissions,
    int? score,
    String? seasonId,
  }) {
    return LeaderboardEntryEntity(
      userId: userId ?? this.userId,
      rank: rank ?? this.rank,
      previousRank: previousRank ?? this.previousRank,
      username: username ?? this.username,
      university: university ?? this.university,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      streakDays: streakDays ?? this.streakDays,
      badges: badges ?? this.badges,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isPremium: isPremium ?? this.isPremium,
      accuracyPercent: accuracyPercent ?? this.accuracyPercent,
      completedCategories: completedCategories ?? this.completedCategories,
      completedMissions: completedMissions ?? this.completedMissions,
      score: score ?? this.score,
      seasonId: seasonId ?? this.seasonId,
    );
  }
}