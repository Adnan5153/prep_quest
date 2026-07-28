import '../../../../shared/typedefs/result.dart';
import '../entities/sync_task_entity.dart';
import '../repositories/offline_repository.dart';

class SyncOfflineData {
  SyncOfflineData(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<SyncTaskEntity>>> call() => _repository.syncNow();
}

class EnqueueSync {
  EnqueueSync(this._repository);
  final OfflineRepository _repository;

  Future<Result<SyncTaskEntity>> call({
    required SyncSource source,
    required SyncPayloadType payloadType,
    required Map<String, dynamic> payload,
  }) =>
      _repository.enqueueSync(
        source: source,
        payloadType: payloadType,
        payload: payload,
      );
}

class GetSyncQueue {
  GetSyncQueue(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<SyncTaskEntity>>> call() =>
      _repository.getSyncQueue();
}