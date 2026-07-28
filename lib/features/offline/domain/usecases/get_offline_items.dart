import '../../../../shared/typedefs/result.dart';
import '../entities/download_task_entity.dart';
import '../entities/offline_item_entity.dart';
import '../enums/offline_content_type.dart';
import '../repositories/offline_repository.dart';

class GetOfflineItems {
  GetOfflineItems(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<OfflineItemEntity>>> call({
    OfflineContentType? filter,
  }) =>
      _repository.getOfflineItems(filter: filter);
}

class GetDownloadQueue {
  GetDownloadQueue(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<DownloadTaskEntity>>> call() =>
      _repository.getDownloadQueue();
}

class GetDownloadedLessons {
  GetDownloadedLessons(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<OfflineItemEntity>>> call() =>
      _repository.getDownloadedLessons();
}

class GetDownloadedQuestions {
  GetDownloadedQuestions(this._repository);
  final OfflineRepository _repository;

  Future<Result<List<OfflineItemEntity>>> call() =>
      _repository.getDownloadedQuestionSets();
}