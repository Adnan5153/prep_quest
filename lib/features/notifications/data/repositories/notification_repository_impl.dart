import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

/// Concrete [NotificationRepository] with remote-first local fallback.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = false,
  });

  final NotificationLocalDataSource local;
  final NotificationRemoteDataSource? remote;
  final bool preferRemote;

  @override
  Future<Result<List<NotificationEntity>>> fetchAll() async {
    try {
      return Result.success(_entities(_readAll()));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> markAsRead(String id) async {
    return _mutate((NotificationModel row) =>
        row.id == id ? row.copyWith(isRead: true) : row);
  }

  @override
  Future<Result<List<NotificationEntity>>> markAllAsRead() async {
    return _mutate((NotificationModel row) => row.copyWith(isRead: true));
  }

  @override
  Future<Result<List<NotificationEntity>>> delete(String id) async {
    try {
      final List<NotificationModel> rows =
          _readAll().where((NotificationModel row) => row.id != id).toList();
      local.writeAll(rows);
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  Future<Result<List<NotificationEntity>>> _mutate(
    NotificationModel Function(NotificationModel row) transform,
  ) async {
    try {
      final List<NotificationModel> rows = _readAll().map(transform).toList();
      local.writeAll(rows);
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  List<NotificationModel> _readAll() {
    if (preferRemote && remote != null) {
      try {
        return remote!.readAll();
      } catch (_) {
        return local.readAll();
      }
    }
    return local.readAll();
  }

  List<NotificationEntity> _entities(List<NotificationModel> rows) {
    return List<NotificationEntity>.unmodifiable(
      rows.map((NotificationModel row) => row.toEntity()),
    );
  }
}
