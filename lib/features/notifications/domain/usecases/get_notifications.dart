import '../../../../shared/typedefs/result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Loads every notification.
class GetNotifications {
  const GetNotifications(this._repository);
  final NotificationRepository _repository;
  Future<Result<List<NotificationEntity>>> call() => _repository.fetchAll();
}
