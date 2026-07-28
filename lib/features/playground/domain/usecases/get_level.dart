import '../../../../shared/typedefs/result.dart';
import '../entities/level_entity.dart';
import '../repositories/playground_repository.dart';

/// Returns the level attached to the given node id.
///
/// The repository contract resolves the level via the node id so the
/// caller does not need to track `levelId` separately.
class GetLevelUseCase {
  const GetLevelUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<LevelEntity?>> call(String nodeId) =>
      _repository.getLevel(nodeId);
}