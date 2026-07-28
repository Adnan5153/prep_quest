import '../../../../shared/typedefs/result.dart';
import '../repositories/playground_repository.dart';

/// Marks the supplied node's level as started.
///
/// Idempotent — calling twice does not double-persist or regress
/// progress. The repository is responsible for locking down calls on
/// locked nodes.
class StartLevelUseCase {
  const StartLevelUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<NodeActionResult>> call(String nodeId) =>
      _repository.startLevel(nodeId);
}