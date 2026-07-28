import '../../../../shared/typedefs/result.dart';
import '../entities/reward_history_entry.dart';
import '../repositories/rewards_repository.dart';

/// Loads recent reward grants, newest first.
class LoadRewardHistory {
  const LoadRewardHistory(this._repository);

  final RewardsRepository _repository;

  Future<Result<List<RewardHistoryEntry>>> call({int limit = 50}) {
    return _repository.loadHistory(limit: limit);
  }
}