import '../../../../shared/typedefs/result.dart';
import '../enums/offline_content_type.dart';
import '../entities/download_task_entity.dart';
import '../entities/offline_item_entity.dart';
import '../entities/storage_usage_entity.dart';
import '../entities/sync_task_entity.dart';

/// Domain contract for offline content management.
abstract class OfflineRepository {
  Future<Result<List<OfflineItemEntity>>> getOfflineItems({
    OfflineContentType? filter,
  });

  Future<Result<OfflineItemEntity?>> getOfflineItem(String id);

  Future<Result<DownloadTaskEntity>> enqueueDownload({
    required String contentId,
    required String title,
    required OfflineContentType contentType,
    required int totalBytes,
  });

  Future<Result<DownloadTaskEntity>> pauseDownload(String taskId);

  Future<Result<DownloadTaskEntity>> resumeDownload(String taskId);

  Future<Result<bool>> cancelDownload(String taskId);

  Future<Result<List<DownloadTaskEntity>>> getDownloadQueue();

  Future<Result<bool>> deleteOfflineItem(String id);

  Future<Result<List<OfflineItemEntity>>> getDownloadedLessons();

  Future<Result<List<OfflineItemEntity>>> getDownloadedQuestionSets();

  Future<Result<StorageUsageEntity>> getStorageUsage();

  Future<Result<List<SyncTaskEntity>>> getSyncQueue();

  Future<Result<SyncTaskEntity>> enqueueSync({
    required SyncSource source,
    required SyncPayloadType payloadType,
    required Map<String, dynamic> payload,
  });

  Future<Result<List<SyncTaskEntity>>> syncNow();

  Future<Result<bool>> clearCache();

  Future<Result<bool>> deleteAllDownloads();
}
