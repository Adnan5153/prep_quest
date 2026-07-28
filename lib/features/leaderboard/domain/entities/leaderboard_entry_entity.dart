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
    );
  }
}