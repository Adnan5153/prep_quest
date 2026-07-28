import '../../../../shared/typedefs/result.dart';
import '../entities/leaderboard_category_entity.dart';
import '../enums/leaderboard_enums.dart';
import '../repositories/leaderboard_repository.dart';

/// Loads the University leaderboard.
class GetUniversityLeaderboard {
  const GetUniversityLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Future<Result<LeaderboardCategoryEntity>> call() {
    return _repository.fetch(LeaderboardScope.university);
  }
}