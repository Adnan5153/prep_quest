import 'package:flutter/foundation.dart';

import 'badge_entry.dart';
import 'chest_entry.dart';
import 'level_progress.dart';
import 'reward_history_entry.dart';
import 'streak_state.dart';

/// Aggregated, read-only snapshot of every reward a user owns.
///
/// The presentation layer reads this from the controller. The reward
/// engine produces new copies via [copyWith] — never mutates in place.
@immutable
class UserRewardsState {
  const UserRewardsState({
    required this.totalXP,
    required this.totalCoins,
    required this.level,
    required this.streak,
    required this.badges,
    required this.chests,
    required this.history,
    required this.favoriteBadgeIds,
  });

  factory UserRewardsState.initial() {
    return UserRewardsState(
      totalXP: 0,
      totalCoins: 0,
      level: const LevelProgress(
        currentLevel: 1,
        currentXP: 0,
        nextLevelXP: 100,
      ),
      streak: const StreakState(
        currentDays: 0,
        bestDays: 0,
        lastClaimedAtIso: '',
      ),
      badges: const <BadgeEntry>[],
      chests: const <ChestEntry>[],
      history: const <RewardHistoryEntry>[],
      favoriteBadgeIds: const <String>{},
    );
  }

  final int totalXP;

  /// Deprecated: read `UserProfile.progression.coins` instead. This
  /// in-memory mirror is kept for legacy UI widgets that have not yet
  /// been migrated to `coinBalanceProvider`. The canonical coin
  /// authority is the Firestore progression document maintained by
  /// `CoinService` (Phase 41).
  @Deprecated('Read UserProfile.progression.coins via coinBalanceProvider.')
  final int totalCoins;

  final LevelProgress level;
  final StreakState streak;
  final List<BadgeEntry> badges;
  final List<ChestEntry> chests;
  final List<RewardHistoryEntry> history;
  final Set<String> favoriteBadgeIds;

  UserRewardsState copyWith({
    int? totalXP,
    int? totalCoins,
    LevelProgress? level,
    StreakState? streak,
    List<BadgeEntry>? badges,
    List<ChestEntry>? chests,
    List<RewardHistoryEntry>? history,
    Set<String>? favoriteBadgeIds,
  }) {
    return UserRewardsState(
      totalXP: totalXP ?? this.totalXP,
      totalCoins: totalCoins ?? this.totalCoins,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
      chests: chests ?? this.chests,
      history: history ?? this.history,
      favoriteBadgeIds: favoriteBadgeIds ?? this.favoriteBadgeIds,
    );
  }
}