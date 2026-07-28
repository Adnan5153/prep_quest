import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../entities/node_entity.dart';
import '../repositories/playground_repository.dart';

/// Returns the next node that is currently eligible to unlock.
///
/// Phase 4 makes this a read-only helper: the repository already
/// promotes the next eligible node to `unlocked` whenever a level is
/// completed (idempotently). This use case surfaces that single
/// candidate so the controller can decide whether to focus the camera
/// on it after a level finishes.
class UnlockNextLevelUseCase {
  const UnlockNextLevelUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<NodeEntity?>> call() async {
    try {
      final Result<dynamic> worldResult = await _repository.getWorldMap();
      return worldResult.fold<Result<NodeEntity?>>(
        onFailure: (Failure failure) => Result<NodeEntity?>.failure(failure),
        onSuccess: (dynamic world) {
          final List<NodeEntity> candidates =
              (world.nextUnlockedCandidates as List<NodeEntity>);
          if (candidates.isEmpty) {
            return Result<NodeEntity?>.success(null);
          }
          return Result<NodeEntity?>.success(candidates.first);
        },
      );
    } catch (error) {
      return Result<NodeEntity?>.failure(
        UnknownFailure('Could not resolve next unlock: $error'),
      );
    }
  }
}