import '../../../../shared/typedefs/result.dart';
import '../entities/storage_usage_entity.dart';
import '../repositories/offline_repository.dart';

class GetStorageUsage {
  GetStorageUsage(this._repository);
  final OfflineRepository _repository;

  Future<Result<StorageUsageEntity>> call() =>
      _repository.getStorageUsage();
}

class ClearCache {
  ClearCache(this._repository);
  final OfflineRepository _repository;

  Future<Result<bool>> call() => _repository.clearCache();
}

class DeleteAllDownloads {
  DeleteAllDownloads(this._repository);
  final OfflineRepository _repository;

  Future<Result<bool>> call() => _repository.deleteAllDownloads();
}