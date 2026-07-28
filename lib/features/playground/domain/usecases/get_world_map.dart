import '../../../../shared/typedefs/result.dart';
import '../entities/world_entity.dart';
import '../repositories/playground_repository.dart';

/// Returns the world map for the active user.
///
/// Single-purpose wrapper around [PlaygroundRepository.getWorldMap].
class GetWorldMapUseCase {
  const GetWorldMapUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<WorldEntity>> call() => _repository.getWorldMap();
}