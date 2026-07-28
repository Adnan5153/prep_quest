import '../../domain/entities/badge_entry.dart';
import '../../domain/entities/chest_entry.dart';
import '../../domain/entities/reward_history_entry.dart';
import '../../domain/entities/user_rewards_state.dart';
import 'badge_entry_model.dart';
import 'chest_entry_model.dart';
import 'level_progress_model.dart';
import 'reward_history_entry_model.dart';
import 'streak_state_model.dart';

class UserRewardsStateModel {
  const UserRewardsStateModel({
    required this.totalXP,
    required this.totalCoins,
    required this.level,
    required this.streak,
    required this.badges,
    required this.chests,
    required this.history,
    required this.favoriteBadgeIds,
  });

  final int totalXP;
  final int totalCoins;
  final LevelProgressModel level;
  final StreakStateModel streak;
  final List<BadgeEntryModel> badges;
  final List<ChestEntryModel> chests;
  final List<RewardHistoryEntryModel> history;
  final Set<String> favoriteBadgeIds;

  UserRewardsState toEntity() {
    return UserRewardsState(
      totalXP: totalXP,
      totalCoins: totalCoins,
      level: level.toEntity(),
      streak: streak.toEntity(),
      badges: List<BadgeEntry>.unmodifiable(
        badges.map((BadgeEntryModel b) => b.toEntity()),
      ),
      chests: List<ChestEntry>.unmodifiable(
        chests.map((ChestEntryModel c) => c.toEntity()),
      ),
      history: List<RewardHistoryEntry>.unmodifiable(
        history.map((RewardHistoryEntryModel h) => h.toEntity()),
      ),
      favoriteBadgeIds: Set<String>.unmodifiable(favoriteBadgeIds),
    );
  }
}