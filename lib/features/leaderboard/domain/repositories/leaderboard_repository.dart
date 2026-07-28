import '../../../../shared/typedefs/result.dart';
import '../entities/leaderboard_category_entity.dart';
import '../enums/leaderboard_enums.dart';

/// Storage contract for the leaderboard feature.
///
/// Each fetch returns a fully populated [LeaderboardCategoryEntity];
/// the presentation layer never knows which datasource served it.
abstract class LeaderboardRepository {
  /// Returns the leaderboard for a single scope.
  Future<Result<LeaderboardCategoryEntity>> fetch(LeaderboardScope scope);

  /// Returns all five scopes in parallel — used by the hub screen.
  Future<Result<List<LeaderboardCategoryEntity>>> fetchAll();
}