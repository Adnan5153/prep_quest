import '../../../../shared/typedefs/result.dart';
import '../entities/level_progress.dart';
import '../entities/reward.dart';
import '../entities/reward_event.dart';
import '../entities/reward_history_entry.dart';
import '../entities/reward_outcome.dart';
import '../entities/user_rewards_state.dart';
import '../enums/reward_enums.dart';

/// Contract that the presentation layer consumes. The data layer
/// implements this in `RewardsRepositoryImpl`; presentation never
/// talks to datasources directly.
abstract class RewardsRepository {
  Future<Result<UserRewardsState>> loadState();

  Future<Result<RewardOutcome>> grantFromTrigger({
    required RewardTrigger trigger,
    required RewardTriggerData data,
    required UserRewardsState currentState,
  });

  Future<Result<RewardOutcome>> openChest({
    required String chestId,
    required UserRewardsState currentState,
  });

  Future<Result<RewardOutcome>> claimDailyReward({
    required int day,
    required UserRewardsState currentState,
  });

  Future<Result<List<RewardHistoryEntry>>> loadHistory({int limit = 50});

  Future<Result<bool>> toggleBadgeFavorite(String badgeId);

  Future<Result<List<DailyRewardTemplate>>> loadDailyRewardTemplate();

  Future<Result<List<ChestTemplate>>> loadChestTemplates();

  Future<Result<LevelProgress>> previewNextLevel(int xp);
}

/// Catalog template — the engine maps these onto user-owned entries.
class DailyRewardTemplate {
  const DailyRewardTemplate({
    required this.day,
    required this.xp,
    required this.coins,
    this.badgeIconKey,
    this.title,
  });

  final int day;
  final int xp;
  final int coins;
  final String? badgeIconKey;
  final String? title;
}

class ChestTemplate {
  const ChestTemplate({
    required this.id,
    required this.title,
    required this.rarityId,
    required this.previewRolls,
  });

  final String id;
  final String title;
  final String rarityId;
  final List<Reward> previewRolls;
}

/// Helper type alias so the rest of the codebase can talk about
/// "today's streak day" without leaking the trigger-data enum.
typedef TodayDayResolver = int Function();

/// Helper type alias so callers can ask the engine for a deterministic
/// but pluggable RNG (used by chests).
typedef RewardRng = int Function(int maxExclusive);