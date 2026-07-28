import '../../../../shared/typedefs/result.dart';
import '../repositories/rewards_repository.dart';

/// Loads the static 7-day daily-reward calendar template.
class LoadDailyRewardTemplate {
  const LoadDailyRewardTemplate(this._repository);

  final RewardsRepository _repository;

  Future<Result<List<DailyRewardTemplate>>> call() {
    return _repository.loadDailyRewardTemplate();
  }
}