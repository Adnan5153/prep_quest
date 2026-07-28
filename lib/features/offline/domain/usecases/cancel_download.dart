import '../../../../shared/typedefs/result.dart';
import '../repositories/offline_repository.dart';

class CancelDownload {
  CancelDownload(this._repository);
  final OfflineRepository _repository;

  Future<Result<bool>> call(String taskId) =>
      _repository.cancelDownload(taskId);
}