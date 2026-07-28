import '../../../../shared/typedefs/result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Removes a single notification from the list.
class DeleteNotification {
  const DeleteNotification(this._repository);
  final NotificationRepository _repository;
  Future<Result<List<NotificationEntity>>> call(String id) =>
      _repository.delete(id);
}