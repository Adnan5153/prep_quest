import '../../../../shared/typedefs/result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Marks every notification as read.
class MarkAllAsRead {
  const MarkAllAsRead(this._repository);
  final NotificationRepository _repository;
  Future<Result<List<NotificationEntity>>> call() =>
      _repository.markAllAsRead();
}
