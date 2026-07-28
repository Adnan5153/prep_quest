import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_all_as_read.dart';
import '../../domain/usecases/mark_as_read.dart';

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>(
  (ref) => NotificationLocalDataSource(),
);

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>(
  (ref) => const NotificationRemoteDataSource(),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(
    local: ref.watch(notificationLocalDataSourceProvider),
    remote: ref.watch(notificationRemoteDataSourceProvider),
  ),
);

final getNotificationsUseCaseProvider = Provider<GetNotifications>(
  (ref) => GetNotifications(ref.watch(notificationRepositoryProvider)),
);

final markAsReadUseCaseProvider = Provider<MarkAsRead>(
  (ref) => MarkAsRead(ref.watch(notificationRepositoryProvider)),
);

final markAllAsReadUseCaseProvider = Provider<MarkAllAsRead>(
  (ref) => MarkAllAsRead(ref.watch(notificationRepositoryProvider)),
);

final deleteNotificationUseCaseProvider = Provider<DeleteNotification>(
  (ref) => DeleteNotification(ref.watch(notificationRepositoryProvider)),
);

@immutable
class NotificationViewState {
  const NotificationViewState({
    required this.status,
    required this.items,
    this.errorMessage,
  });

  final NotificationStatus status;
  final List<NotificationEntity> items;
  final String? errorMessage;

  int get unreadCount => items.where((NotificationEntity e) => !e.isRead).length;

  NotificationViewState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationViewState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const NotificationViewState initial = NotificationViewState(
    status: NotificationStatus.initial,
    items: <NotificationEntity>[],
  );
}

enum NotificationStatus { initial, loading, ready, error }

class NotificationController extends StateNotifier<NotificationViewState> {
  NotificationController({
    required this.getNotifications,
    required this.markAsRead,
    required this.markAllAsRead,
    required this.deleteNotification,
  }) : super(NotificationViewState.initial);

  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final MarkAllAsRead markAllAsRead;
  final DeleteNotification deleteNotification;

  Future<void> load() async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      clearError: true,
    );
    final Result<List<NotificationEntity>> result = await getNotifications();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (items) {
        state = state.copyWith(
          status: NotificationStatus.ready,
          items: items,
          clearError: true,
        );
      },
    );
  }

  Future<void> markRead(String id) async {
    final Result<List<NotificationEntity>> result = await markAsRead(id);
    result.fold(
      onFailure: (_) {},
      onSuccess: (items) {
        state = state.copyWith(items: items);
      },
    );
  }

  Future<void> markAllRead() async {
    final Result<List<NotificationEntity>> result = await markAllAsRead();
    result.fold(
      onFailure: (_) {},
      onSuccess: (items) {
        state = state.copyWith(items: items);
      },
    );
  }

  Future<void> remove(String id) async {
    final Result<List<NotificationEntity>> result =
        await deleteNotification(id);
    result.fold(
      onFailure: (_) {},
      onSuccess: (items) {
        state = state.copyWith(items: items);
      },
    );
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationViewState>(
  (ref) => NotificationController(
    getNotifications: ref.watch(getNotificationsUseCaseProvider),
    markAsRead: ref.watch(markAsReadUseCaseProvider),
    markAllAsRead: ref.watch(markAllAsReadUseCaseProvider),
    deleteNotification: ref.watch(deleteNotificationUseCaseProvider),
  ),
);

/// Convenience: just the unread count.
final notificationUnreadCountProvider = Provider<int>(
  (ref) => ref.watch(notificationControllerProvider).unreadCount,
);