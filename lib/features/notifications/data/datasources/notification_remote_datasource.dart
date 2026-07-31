import '../../../../core/services/notification_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../models/notification_model.dart';

/// Firestore-backed notification source of truth (Phase 48).
///
/// All writes go through [NotificationService] which owns the
/// `users/{uid}/notifications/{notificationId}` collection plus
/// `users/{uid}/fcm_tokens/{deviceId}` for device registration.
class NotificationRemoteDataSource {
  NotificationRemoteDataSource({
    required this.service,
    required this.uidProvider,
  });

  final NotificationService service;

  /// Resolves the authenticated uid (empty string = guest).
  final String Function() uidProvider;

  /// One-shot read used by `NotificationRepositoryImpl.fetchAll()`
  /// to seed the local cache from Firestore.
  Future<List<NotificationModel>> readAll() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const <NotificationModel>[];
    return service.snapshot(uid);
  }

  /// Persists a notification row. Returns the persisted model so the
  /// local cache can mirror the canonical docId + createdAtIso.
  Future<Result<NotificationModel>> upsert(NotificationModel model) async {
    final String uid = uidProvider();
    if (uid.isEmpty) return Result<NotificationModel>.success(model);
    final NotificationModel persisted = await service.upsert(uid: uid, model: model);
    return Result<NotificationModel>.success(persisted);
  }

  /// Marks a single notification as read. Returns `true` on success.
  Future<Result<bool>> markAsRead(String id) async {
    final String uid = uidProvider();
    if (uid.isEmpty || id.isEmpty) return const Result<bool>.success(false);
    final bool ok = await service.markAsRead(uid: uid, notificationId: id);
    return Result<bool>.success(ok);
  }

  /// Marks every notification as read via a WriteBatch.
  Future<Result<int>> markAllAsRead() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const Result<int>.success(0);
    final int count = await service.markAllAsRead(uid);
    return Result<int>.success(count);
  }

  /// Removes a single notification. Returns `true` when the doc
  /// existed (and was deleted).
  Future<Result<bool>> remove(String id) async {
    final String uid = uidProvider();
    if (uid.isEmpty || id.isEmpty) return const Result<bool>.success(false);
    final bool removed = await service.remove(uid: uid, notificationId: id);
    return Result<bool>.success(removed);
  }
}
