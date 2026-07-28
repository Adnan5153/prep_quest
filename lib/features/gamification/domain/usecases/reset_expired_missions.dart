import '../../../../shared/typedefs/result.dart';
import '../repositories/mission_repository.dart';

/// Forces a sweep over every mission — any expired entry is replaced
/// with a fresh instance.
class ResetExpiredMissions {
  const ResetExpiredMissions(this._repository);

  final MissionRepository _repository;

  Future<Result<int>> call() {
    return _repository.resetExpired();
  }
}