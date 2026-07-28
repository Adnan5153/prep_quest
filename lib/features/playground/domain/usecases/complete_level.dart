import '../../../../shared/typedefs/result.dart';
import '../repositories/playground_repository.dart';

/// Marks the supplied level as completed.
///
/// Idempotent. Returns the reward payload and the id of the node that
/// was unlocked as a side-effect, if any.
class CompleteLevelUseCase {
  const CompleteLevelUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<NodeActionResult>> call(String nodeId) =>
      _repository.completeLevel(nodeId);
}