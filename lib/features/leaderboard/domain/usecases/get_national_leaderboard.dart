import '../../../../shared/typedefs/result.dart';
import '../entities/leaderboard_category_entity.dart';
import '../enums/leaderboard_enums.dart';
import '../repositories/leaderboard_repository.dart';

/// Loads the National leaderboard.
class GetNationalLeaderboard {
  const GetNationalLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Future<Result<LeaderboardCategoryEntity>> call() {
    return _repository.fetch(LeaderboardScope.national);
  }
}