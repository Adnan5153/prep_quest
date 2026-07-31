import 'package:flutter/foundation.dart';

import '../enums/leaderboard_enums.dart';
import 'leaderboard_entry_entity.dart';

/// Per-user ranking snapshot hydrated from the canonical profile +
/// statistics + mission progress + streak sources. One document per
/// user per scope lives at
/// `users/{uid}/leaderboard_entries/{scopeId}` and is rebuilt by
/// `LeaderboardService.recordQuizCompletion` whenever the user's
/// profile mutates. The service is the **only** writer; the
/// repository merely reads it back into the
/// [LeaderboardEntryEntity] shape the UI already consumes.
///
/// Ranking inputs (all required by the Phase 44 spec):
/// * `xp` — copied from `ProgressionEntity.totalXp`.
/// * `level` — copied from `ProgressionEntity.level`.
/// * `coins` — copied from `ProgressionEntity.coins`.
/// * `streakDays` — copied from `StreakState.currentDays`.
/// * `accuracyPercent` — copied from `UserStatisticsEntity.accuracy`.
/// * `completedCategories` — count of `CategoryStatisticsEntity` rows
///   with `bestScore >= 60`.
/// * `completedMissions` — count of `MissionSummaryEntity` rows with
///   `completionStatus == perfect || completionStatus == completed`.
@immutable
class LeaderboardRankingEntity {
  const LeaderboardRankingEntity({
    required this.uid,
    required this.scope,
    required this.seasonId,
    required this.username,
    required this.university,
    required this.avatarUrl,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streakDays,
    required this.accuracyPercent,
    required this.completedCategories,
    required this.completedMissions,
    required this.badges,
    required this.isPremium,
    required this.previousRank,
    required this.lastUpdatedAtIso,
  });

  /// Authenticated user id. Empty for offline / guests.
  final String uid;

  /// Which scope this row belongs to.
  final LeaderboardScope scope;

  /// The seasonal identifier (`LeaderboardSeason.currentSeasonId`)
  /// so weekly / seasonal rows can roll over without colliding with
  /// lifetime / national rows. National + university + friends rows
  /// always write to `seasonId = 'lifetime'`.
  final String seasonId;

  /// Display name resolved at write time so the row stays labelled
  /// even if the user renames themselves later.
  final String username;

  /// University name resolved at write time.
  final String university;

  /// Optional avatar URL — empty string falls back to initials.
  final String avatarUrl;

  /// User's level at write time.
  final int level;

  /// Lifetime XP at write time.
  final int xp;

  /// Coin balance at write time.
  final int coins;

  /// Current streak in days at write time.
  final int streakDays;

  /// 0-100 lifetime accuracy across every category.
  final int accuracyPercent;

  /// Count of categories with `bestScore >= 60`.
  final int completedCategories;

  /// Count of missions in `completed | perfect` status.
  final int completedMissions;

  /// Earned badge ids (e.g. `['quiz_master', 'streak_legend']`).
  final List<String> badges;

  /// Whether the user holds a premium subscription — surfaced as
  /// the gold `PRO` badge on the leaderboard tile.
  final bool isPremium;

  /// Snapshot of the previous rank — preserved across writes so the
  /// UI can render the up/down rank-change indicator even when the
  /// listener hasn't received a previous frame yet.
  final int previousRank;

  /// ISO-8601 UTC timestamp of the last mutation.
  final String? lastUpdatedAtIso;

  /// Renders the legacy [LeaderboardEntryEntity] shape so every
  /// existing widget / screen / use case keeps compiling. The caller
  /// is responsible for assigning `rank` (it is computed at read-time
  /// when the snapshot is materialised).
  LeaderboardEntryEntity toLegacyEntry({
    required int rank,
    required bool isCurrentUser,
  }) {
    return LeaderboardEntryEntity(
      userId: uid,
      rank: rank,
      previousRank: previousRank,
      username: username,
      university: university,
      avatarUrl: avatarUrl,
      level: level,
      xp: xp,
      coins: coins,
      streakDays: streakDays,
      badges: List<String>.unmodifiable(badges),
      isCurrentUser: isCurrentUser,
      isPremium: isPremium,
    );
  }

  /// Composite ranking score used to order users within a scope.
  ///
  /// Formula (Phase 44 — relative-weighted):
  ///   xp                          (weight 1.0)
  /// + level * 100                 (weight 1.0; levels aggregate 100 XP each)
  /// + completedCategories * 50    (weight 1.0)
  /// + completedMissions * 75      (weight 1.0)
  /// + accuracyPercent             (weight 1.0; capped 0-100)
  /// + coins * 0.05                (small weight — coins are easy to earn)
  /// + streakDays * 20             (streak reward)
  int get score {
    return xp +
        (level * 100) +
        (completedCategories * 50) +
        (completedMissions * 75) +
        accuracyPercent +
        (coins * 0.05).round() +
        (streakDays * 20);
  }

  LeaderboardRankingEntity copyWith({
    String? uid,
    LeaderboardScope? scope,
    String? seasonId,
    String? username,
    String? university,
    String? avatarUrl,
    int? level,
    int? xp,
    int? coins,
    int? streakDays,
    int? accuracyPercent,
    int? completedCategories,
    int? completedMissions,
    List<String>? badges,
    bool? isPremium,
    int? previousRank,
    String? lastUpdatedAtIso,
  }) {
    return LeaderboardRankingEntity(
      uid: uid ?? this.uid,
      scope: scope ?? this.scope,
      seasonId: seasonId ?? this.seasonId,
      username: username ?? this.username,
      university: university ?? this.university,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      streakDays: streakDays ?? this.streakDays,
      accuracyPercent: accuracyPercent ?? this.accuracyPercent,
      completedCategories: completedCategories ?? this.completedCategories,
      completedMissions: completedMissions ?? this.completedMissions,
      badges: badges ?? this.badges,
      isPremium: isPremium ?? this.isPremium,
      previousRank: previousRank ?? this.previousRank,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'scope': scope.name,
      'seasonId': seasonId,
      'username': username,
      'university': university,
      'avatarUrl': avatarUrl,
      'level': level,
      'xp': xp,
      'coins': coins,
      'streakDays': streakDays,
      'accuracyPercent': accuracyPercent,
      'completedCategories': completedCategories,
      'completedMissions': completedMissions,
      'badges': List<String>.from(badges, growable: false),
      'isPremium': isPremium,
      'previousRank': previousRank,
      'lastUpdatedAtIso': lastUpdatedAtIso,
    };
  }

  static LeaderboardRankingEntity fromMap(Map<String, dynamic> map) {
    final List<String> rawBadges = (map['badges'] as List<dynamic>?)
            ?.map((dynamic entry) => entry?.toString() ?? '')
            .where((String entry) => entry.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    return LeaderboardRankingEntity(
      uid: (map['uid'] as String?) ?? '',
      scope: _parseScope(map['scope']?.toString()),
      seasonId: (map['seasonId'] as String?) ?? 'lifetime',
      username: (map['username'] as String?) ?? '',
      university: (map['university'] as String?) ?? '',
      avatarUrl: (map['avatarUrl'] as String?) ?? '',
      level: (map['level'] as num?)?.toInt() ?? 1,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      accuracyPercent: (map['accuracyPercent'] as num?)?.toInt() ?? 0,
      completedCategories:
          (map['completedCategories'] as num?)?.toInt() ?? 0,
      completedMissions: (map['completedMissions'] as num?)?.toInt() ?? 0,
      badges: rawBadges,
      isPremium: (map['isPremium'] as bool?) ?? false,
      previousRank: (map['previousRank'] as num?)?.toInt() ?? 0,
      lastUpdatedAtIso: map['lastUpdatedAtIso'] as String?,
    );
  }

  static LeaderboardScope _parseScope(String? value) {
    if (value == null) return LeaderboardScope.national;
    for (final LeaderboardScope s in LeaderboardScope.values) {
      if (s.name == value) return s;
    }
    return LeaderboardScope.national;
  }

  /// Empty mirror used by the in-memory datasource and the offline
  /// fallback. Always represents the lifetime national scope.
  static const LeaderboardRankingEntity empty = LeaderboardRankingEntity(
    uid: '',
    scope: LeaderboardScope.national,
    seasonId: 'lifetime',
    username: '',
    university: '',
    avatarUrl: '',
    level: 1,
    xp: 0,
    coins: 0,
    streakDays: 0,
    accuracyPercent: 0,
    completedCategories: 0,
    completedMissions: 0,
    badges: <String>[],
    isPremium: false,
    previousRank: 0,
    lastUpdatedAtIso: null,
  );
}