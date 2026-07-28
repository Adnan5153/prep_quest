import '../../../../shared/typedefs/result.dart';
import '../entities/download_task_entity.dart';
import '../repositories/offline_repository.dart';

class ResumeDownload {
  ResumeDownload(this._repository);
  final OfflineRepository _repository;

  Future<Result<DownloadTaskEntity>> call(String taskId) =>
      _repository.resumeDownload(taskId);
}