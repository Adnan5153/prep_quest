import '../../../../shared/typedefs/result.dart';
import '../entities/challenge_entity.dart';
import '../repositories/playground_repository.dart';

/// Returns the ordered list of challenges attached to a level.
class GetChallengesUseCase {
  const GetChallengesUseCase(this._repository);

  final PlaygroundRepository _repository;

  Future<Result<List<ChallengeEntity>>> call(String levelId) =>
      _repository.getChallenges(levelId);
}