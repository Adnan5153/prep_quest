import '../../../../shared/typedefs/result.dart';
import '../entities/notification_entity.dart';

/// Storage contract for the Notifications feature.
abstract class NotificationRepository {
  Future<Result<List<NotificationEntity>>> fetchAll();
  Future<Result<List<NotificationEntity>>> markAsRead(String id);
  Future<Result<List<NotificationEntity>>> markAllAsRead();
  Future<Result<List<NotificationEntity>>> delete(String id);
}
