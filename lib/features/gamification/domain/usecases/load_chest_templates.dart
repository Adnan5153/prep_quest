import '../../../../shared/typedefs/result.dart';
import '../repositories/rewards_repository.dart';

/// Loads the catalogue of chest templates the engine can grant.
class LoadChestTemplates {
  const LoadChestTemplates(this._repository);

  final RewardsRepository _repository;

  Future<Result<List<ChestTemplate>>> call() {
    return _repository.loadChestTemplates();
  }
}