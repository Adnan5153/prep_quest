import '../../../../shared/typedefs/result.dart';
import '../entities/download_task_entity.dart';
import '../repositories/offline_repository.dart';

class PauseDownload {
  PauseDownload(this._repository);
  final OfflineRepository _repository;

  Future<Result<DownloadTaskEntity>> call(String taskId) =>
      _repository.pauseDownload(taskId);
}