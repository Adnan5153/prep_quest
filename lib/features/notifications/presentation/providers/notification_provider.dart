import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_all_as_read.dart';
import '../../domain/usecases/mark_as_read.dart';

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>(
  (Ref ref) => NotificationLocalDataSource(),
);

/// Resolves the authenticated uid from [authStateProvider]. Returns
/// an empty string for guests / unauthenticated users — the remote
/// datasource treats empty uids as a no-op (Firestore writes
/// skipped).
final notificationCurrentUidProvider = Provider<String>((Ref ref) {
  final auth = ref.watch(authStateProvider);
  return auth.user?.id ?? '';
});

/// Firestore-backed remote source. The single-writer
/// [NotificationService] owns the canonical schema.
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((Ref ref) {
  return NotificationRemoteDataSource(
    service: ref.watch(notificationServiceProvider),
    uidProvider: () => ref.read(notificationCurrentUidProvider),
  );
});

/// Firestore repository — remote-first, local cache for offline +
/// initial reads. Realtime updates from
/// [userNotificationsStreamProvider] flow into the local mirror via
/// the `remoteStreamFactory` so widgets refresh without manual
/// refresh.
final notificationRepositoryProvider = Provider<NotificationRepository>(
  (Ref ref) {
    final NotificationRepositoryImpl impl = NotificationRepositoryImpl(
      local: ref.watch(notificationLocalDataSourceProvider),
      remote: ref.watch(notificationRemoteDataSourceProvider),
      remoteStreamFactory: () =>
          ref.watch(userNotificationsStreamProvider).maybeWhen(
                data: (List<NotificationModel> rows) =>
                    Stream<List<NotificationModel>>.value(rows),
                orElse: () => Stream<List<NotificationModel>>.value(
                  ref.read(notificationLocalDataSourceProvider).readAll(),
                ),
              ),
      preferRemote: true,
      ref: ref,
    );
    ref.onDispose(impl.cancelRemoteSubscription);
    return impl;
  },
);

final getNotificationsUseCaseProvider = Provider<GetNotifications>(
  (Ref ref) => GetNotifications(ref.watch(notificationRepositoryProvider)),
);

final markAsReadUseCaseProvider = Provider<MarkAsRead>(
  (Ref ref) => MarkAsRead(ref.watch(notificationRepositoryProvider)),
);

final markAllAsReadUseCaseProvider = Provider<MarkAllAsRead>(
  (Ref ref) => MarkAllAsRead(ref.watch(notificationRepositoryProvider)),
);

final deleteNotificationUseCaseProvider = Provider<DeleteNotification>(
  (Ref ref) => DeleteNotification(ref.watch(notificationRepositoryProvider)),
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
    required Ref ref,
  })  : _ref = ref,
        super(NotificationViewState.initial) {
    _remoteSubscription = _ref.listen<AsyncValue<List<NotificationModel>>>(
      userNotificationsStreamProvider,
      (AsyncValue<List<NotificationModel>>? previous,
          AsyncValue<List<NotificationModel>> next) {
        next.whenData((List<NotificationModel> rows) {
          _ref.read(notificationLocalDataSourceProvider).writeAll(rows);
          if (state.status == NotificationStatus.ready) {
            load();
          }
        });
      },
    );
  }

  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final MarkAllAsRead markAllAsRead;
  final DeleteNotification deleteNotification;
  final Ref _ref;

  ProviderSubscription<AsyncValue<List<NotificationModel>>>? _remoteSubscription;

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
    if (!mounted) return;
    result.fold(
      onFailure: (_) {},
      onSuccess: (items) {
        state = state.copyWith(items: items);
      },
    );
  }

  Future<void> markAllRead() async {
    final Result<List<NotificationEntity>> result = await markAllAsRead();
    if (!mounted) return;
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
    if (!mounted) return;
    result.fold(
      onFailure: (_) {},
      onSuccess: (items) {
        state = state.copyWith(items: items);
      },
    );
  }

  @override
  void dispose() {
    _remoteSubscription?.close();
    super.dispose();
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationViewState>(
  (Ref ref) => NotificationController(
    getNotifications: ref.watch(getNotificationsUseCaseProvider),
    markAsRead: ref.watch(markAsReadUseCaseProvider),
    markAllAsRead: ref.watch(markAllAsReadUseCaseProvider),
    deleteNotification: ref.watch(deleteNotificationUseCaseProvider),
    ref: ref,
  ),
);

/// Convenience: just the unread count.
final notificationUnreadCountProvider = Provider<int>(
  (ref) => ref.watch(notificationControllerProvider).unreadCount,
);

/// Registers the current device's FCM token against the authenticated
/// user. Empty uid (guest) is a no-op.
final registerFcmTokenProvider = Provider<Future<bool> Function({
  required String deviceId,
  required String token,
  String? platform,
  Map<String, dynamic>? metadata,
})>((Ref ref) {
  return ({
    required String deviceId,
    required String token,
    String? platform,
    Map<String, dynamic>? metadata,
  }) async {
    final String uid = ref.read(notificationCurrentUidProvider);
    return ref.read(notificationServiceProvider).registerToken(
          uid: uid,
          deviceId: deviceId,
          token: token,
          platform: platform,
          metadata: metadata,
        );
  };
});

/// Unregisters the current device's FCM token (sign-out cleanup).
final unregisterFcmTokenProvider =
    Provider<Future<bool> Function({required String deviceId})>((Ref ref) {
  return ({required String deviceId}) async {
    final String uid = ref.read(notificationCurrentUidProvider);
    return ref.read(notificationServiceProvider).unregisterToken(
          uid: uid,
          deviceId: deviceId,
        );
  };
});
