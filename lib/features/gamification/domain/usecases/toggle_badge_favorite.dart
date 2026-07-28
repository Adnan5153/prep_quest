import '../../../../shared/typedefs/result.dart';
import '../repositories/rewards_repository.dart';

/// Toggles the favourite flag on a user-owned badge.
class ToggleBadgeFavorite {
  const ToggleBadgeFavorite(this._repository);

  final RewardsRepository _repository;

  Future<Result<bool>> call(String badgeId) {
    return _repository.toggleBadgeFavorite(badgeId);
  }
}