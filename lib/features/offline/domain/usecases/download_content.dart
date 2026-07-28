import '../../../../shared/typedefs/result.dart';
import '../entities/download_task_entity.dart';
import '../enums/offline_content_type.dart';
import '../repositories/offline_repository.dart';

/// Enqueues a download of a piece of offline content.
class DownloadContent {
  DownloadContent(this._repository);
  final OfflineRepository _repository;

  Future<Result<DownloadTaskEntity>> call({
    required String contentId,
    required String title,
    required OfflineContentType contentType,
    required int totalBytes,
  }) {
    return _repository.enqueueDownload(
      contentId: contentId,
      title: title,
      contentType: contentType,
      totalBytes: totalBytes,
    );
  }
}