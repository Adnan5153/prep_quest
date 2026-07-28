import '../../../../shared/typedefs/result.dart';
import '../repositories/offline_repository.dart';

class DeleteDownload {
  DeleteDownload(this._repository);
  final OfflineRepository _repository;

  Future<Result<bool>> call(String contentId) =>
      _repository.deleteOfflineItem(contentId);
}