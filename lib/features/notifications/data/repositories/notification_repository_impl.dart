import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

/// Concrete [NotificationRepository] with Firestore-first behaviour
/// and an in-memory cache for offline reads (Phase 48).
///
/// Every write is forwarded to [NotificationRemoteDataSource] which
/// delegates to [NotificationService] (the single writer for
/// `users/{uid}/notifications` + `users/{uid}/fcm_tokens`). Realtime
/// updates flow back through [remoteStreamFactory] and overwrite the
/// local cache so the controller + widgets refresh without a manual
/// pull.
///
/// Phase 51 — every mutating method enforces an authenticated
/// precondition via [AuthGuard] before delegating to the remote data
/// source.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.local,
    required NotificationRemoteDataSource remote,
    Stream<List<NotificationModel>> Function()? remoteStreamFactory,
    this.preferRemote = true,
    required Ref ref,
  })  : _remote = remote,
        _remoteStreamFactory = remoteStreamFactory,
        _guard = AuthGuard(ref) {
    _subscribeToRemote();
  }

  final NotificationLocalDataSource local;
  final NotificationRemoteDataSource _remote;
  final Stream<List<NotificationModel>> Function()? _remoteStreamFactory;
  final bool preferRemote;
  final AuthGuard _guard;

  StreamSubscription<List<NotificationModel>>? _remoteSubscription;

  void _subscribeToRemote() {
    final Stream<List<NotificationModel>> Function()? factory =
        _remoteStreamFactory;
    if (factory == null) return;
    _remoteSubscription = factory().listen(
      (List<NotificationModel> rows) {
        local.writeAll(rows);
        developer.log(
          '[NotificationRepository] remote snapshot: ${rows.length} rows',
          name: 'NotificationRepository',
        );
      },
      onError: (Object e, StackTrace st) {
        developer.log(
          '[NotificationRepository] remote stream error: $e',
          error: e,
          stackTrace: st,
          name: 'NotificationRepository',
        );
      },
    );
  }

  /// Cancels the realtime Firestore subscription. Called from
  /// `ref.onDispose` in the provider.
  void cancelRemoteSubscription() {
    _remoteSubscription?.cancel();
    _remoteSubscription = null;
  }

  @override
  Future<Result<List<NotificationEntity>>> fetchAll() async {
    try {
      final List<NotificationModel> rows = local.readAll();
      final List<NotificationEntity> sorted = List<NotificationEntity>.from(
        rows.map((NotificationModel r) => r.toEntity()),
      )..sort((NotificationEntity a, NotificationEntity b) =>
          b.createdAtIso.compareTo(a.createdAtIso));
      return Result.success(List<NotificationEntity>.unmodifiable(sorted));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> markAsRead(String id) async {
    try {
      _guard.assertAuthenticated();
      final List<NotificationModel> rows = local
          .readAll()
          .map((NotificationModel row) =>
              row.id == id ? row.copyWith(isRead: true) : row)
          .toList(growable: false);
      local.writeAll(rows);
      final Result<bool> remoteResult = await _remote.markAsRead(id);
      if (remoteResult.isFailure) {
        developer.log(
          '[NotificationRepository] markAsRead failed (cache-only): '
          '${remoteResult.failureOrNull?.message}',
          name: 'NotificationRepository',
        );
      }
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> markAllAsRead() async {
    try {
      _guard.assertAuthenticated();
      final List<NotificationModel> rows = local
          .readAll()
          .map((NotificationModel row) => row.copyWith(isRead: true))
          .toList(growable: false);
      local.writeAll(rows);
      final Result<int> remoteResult = await _remote.markAllAsRead();
      if (remoteResult.isFailure) {
        developer.log(
          '[NotificationRepository] markAllAsRead failed (cache-only): '
          '${remoteResult.failureOrNull?.message}',
          name: 'NotificationRepository',
        );
      }
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> delete(String id) async {
    try {
      _guard.assertAuthenticated();
      final List<NotificationModel> rows = local
          .readAll()
          .where((NotificationModel row) => row.id != id)
          .toList(growable: false);
      local.writeAll(rows);
      final Result<bool> remoteResult = await _remote.remove(id);
      if (remoteResult.isFailure) {
        developer.log(
          '[NotificationRepository] remove failed (cache-only): '
          '${remoteResult.failureOrNull?.message}',
          name: 'NotificationRepository',
        );
      }
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  List<NotificationEntity> _entities(List<NotificationModel> rows) {
    final List<NotificationEntity> sorted = List<NotificationEntity>.from(
      rows.map((NotificationModel r) => r.toEntity()),
    )..sort((NotificationEntity a, NotificationEntity b) =>
        b.createdAtIso.compareTo(a.createdAtIso));
    return List<NotificationEntity>.unmodifiable(sorted);
  }
}
