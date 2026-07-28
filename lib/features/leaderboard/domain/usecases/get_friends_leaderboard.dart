import '../../../../shared/typedefs/result.dart';
import '../entities/leaderboard_category_entity.dart';
import '../enums/leaderboard_enums.dart';
import '../repositories/leaderboard_repository.dart';

/// Loads the Friends leaderboard.
class GetFriendsLeaderboard {
  const GetFriendsLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Future<Result<LeaderboardCategoryEntity>> call() {
    return _repository.fetch(LeaderboardScope.friends);
  }
}