import '../../../../shared/typedefs/result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Marks a single notification as read.
class MarkAsRead {
  const MarkAsRead(this._repository);
  final NotificationRepository _repository;
  Future<Result<List<NotificationEntity>>> call(String id) =>
      _repository.markAsRead(id);
}
