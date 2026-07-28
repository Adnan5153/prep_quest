import '../../../../shared/typedefs/result.dart';
import '../entities/leaderboard_category_entity.dart';
import '../enums/leaderboard_enums.dart';
import '../repositories/leaderboard_repository.dart';

/// Loads the Weekly leaderboard.
class GetWeeklyLeaderboard {
  const GetWeeklyLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Future<Result<LeaderboardCategoryEntity>> call() {
    return _repository.fetch(LeaderboardScope.weekly);
  }
}