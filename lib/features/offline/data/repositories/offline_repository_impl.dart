// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/download_task_entity.dart';
import '../../domain/entities/offline_item_entity.dart';
import '../../domain/entities/storage_usage_entity.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import '../../domain/repositories/offline_repository.dart';
import '../datasources/offline_local_datasource.dart';
import '../datasources/offline_remote_datasource.dart';
import '../models/download_task_model.dart';
import '../models/offline_item_model.dart';
import '../models/sync_task_model.dart';

class OfflineRepositoryImpl implements OfflineRepository {
  OfflineRepositoryImpl({
    required OfflineLocalDataSource local,
    required OfflineRemoteDataSource remote,
    required StorageService storage,
    DateTime Function()? clock,
    Ref? ref,
  })  : _local = local,
        _remote = remote,
        _storage = storage,
        _clock = clock ?? DateTime.now,
        _guard = ref == null ? null : AuthGuard(ref);

  final OfflineLocalDataSource _local;
  final OfflineRemoteDataSource _remote;
  final StorageService _storage;
  final DateTime Function() _clock;
  final AuthGuard? _guard;

  static const int _defaultKbPerTick = 320;
  Timer? _ticker;

  // ---- Reads ----------------------------------------------------------------
  @override
  Future<Result<List<OfflineItemEntity>>> getOfflineItems({
    OfflineContentType? filter,
  }) async {
    return Result.success(
      _local.readItems(filter: filter).map((OfflineItemModel m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Result<OfflineItemEntity?>> getOfflineItem(String id) async {
    final OfflineItemModel? model = _local.findItem(id);
    return Result.success(model?.toEntity());
  }

  @override
  Future<Result<List<DownloadTaskEntity>>> getDownloadQueue() async {
    return Result.success(
      _local.readDownloads().map((DownloadTaskModel m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Result<List<OfflineItemEntity>>> getDownloadedLessons() async {
    return Result.success(
      _local
          .readItems(filter: OfflineContentType.lesson)
          .map((OfflineItemModel m) => m.toEntity())
          .toList(),
    );
  }

  @override
  Future<Result<List<OfflineItemEntity>>> getDownloadedQuestionSets() async {
    return Result.success(
      _local
          .readItems(filter: OfflineContentType.questionSet)
          .map((OfflineItemModel m) => m.toEntity())
          .toList(),
    );
  }

  @override
  Future<Result<List<SyncTaskEntity>>> getSyncQueue() async {
    return Result.success(
      _local.readSync().map((SyncTaskModel m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Result<StorageUsageEntity>> getStorageUsage() async {
    final List<OfflineItemModel> items = _local.readItems();
    final int totalBytes =
        items.fold<int>(0, (int sum, OfflineItemModel m) => sum + m.sizeBytes);
    final StorageSnapshot snap = await _storage.snapshot();
    final int largestBytes = items.isEmpty
        ? 0
        : items
            .map((OfflineItemModel m) => m.sizeBytes)
            .reduce((int a, int b) => a > b ? a : b);
    return Result.success(
      StorageUsageEntity(
        totalBytes: (snap.totalMb * 1024 * 1024).round(),
        usedBytes: totalBytes,
        freeBytes: (snap.freeMb * 1024 * 1024).round(),
        lessonCount: items
            .where((OfflineItemModel m) =>
                m.contentTypeName == OfflineContentType.lesson.name)
            .length,
        questionSetCount: items
            .where((OfflineItemModel m) =>
                m.contentTypeName == OfflineContentType.questionSet.name)
            .length,
        largestItemBytes: largestBytes,
      ),
    );
  }

  // ---- Downloads ------------------------------------------------------------
  @override
  Future<Result<DownloadTaskEntity>> enqueueDownload({
    required String contentId,
    required String title,
    required OfflineContentType contentType,
    required int totalBytes,
  }) async {
    _guard?.assertAuthenticated();
    final String id = 'dl_${DateTime.now().microsecondsSinceEpoch}';
    final DownloadTaskModel task = DownloadTaskModel(
      id: id,
      contentId: contentId,
      title: title,
      contentTypeName: contentType.name,
      totalBytes: totalBytes,
      receivedBytes: 0,
      statusName: DownloadStatus.queued.name,
      createdAtIso: _clock().toIso8601String(),
    );
    await _local.writeDownload(task);
    return Result.success(task.toEntity());
  }

  @override
  Future<Result<DownloadTaskEntity>> pauseDownload(String taskId) async {
    final DownloadTaskModel? task = _local.findDownload(taskId);
    if (task == null) {
      return Result.failure(const CacheFailure('Download not found'));
    }
    final DownloadTaskModel updated = DownloadTaskModel(
      id: task.id,
      contentId: task.contentId,
      title: task.title,
      contentTypeName: task.contentTypeName,
      totalBytes: task.totalBytes,
      receivedBytes: task.receivedBytes,
      statusName: DownloadStatus.paused.name,
      createdAtIso: task.createdAtIso,
      completedAtIso: task.completedAtIso,
      errorMessage: task.errorMessage,
    );
    await _local.writeDownload(updated);
    _stopTicker();
    return Result.success(updated.toEntity());
  }

  @override
  Future<Result<DownloadTaskEntity>> resumeDownload(String taskId) async {
    final DownloadTaskModel? task = _local.findDownload(taskId);
    if (task == null) {
      return Result.failure(const CacheFailure('Download not found'));
    }
    final DownloadTaskModel updated = DownloadTaskModel(
      id: task.id,
      contentId: task.contentId,
      title: task.title,
      contentTypeName: task.contentTypeName,
      totalBytes: task.totalBytes,
      receivedBytes: task.receivedBytes,
      statusName: DownloadStatus.downloading.name,
      createdAtIso: task.createdAtIso,
      completedAtIso: task.completedAtIso,
      errorMessage: task.errorMessage,
    );
    await _local.writeDownload(updated);
    _ensureTicker();
    return Result.success(updated.toEntity());
  }

  @override
  Future<Result<bool>> cancelDownload(String taskId) async {
    final DownloadTaskModel? task = _local.findDownload(taskId);
    if (task == null) {
      return Result.failure(const CacheFailure('Download not found'));
    }
    final DownloadTaskModel updated = DownloadTaskModel(
      id: task.id,
      contentId: task.contentId,
      title: task.title,
      contentTypeName: task.contentTypeName,
      totalBytes: task.totalBytes,
      receivedBytes: task.receivedBytes,
      statusName: DownloadStatus.cancelled.name,
      createdAtIso: task.createdAtIso,
      completedAtIso: _clock().toIso8601String(),
      errorMessage: task.errorMessage,
    );
    await _local.writeDownload(updated);
    _stopTicker();
    return Result.success(true);
  }

  // ---- Sync -----------------------------------------------------------------
  @override
  Future<Result<SyncTaskEntity>> enqueueSync({
    required SyncSource source,
    required SyncPayloadType payloadType,
    required Map<String, dynamic> payload,
  }) async {
    final String id = 'sync_${DateTime.now().microsecondsSinceEpoch}';
    _guard?.assertAuthenticated();
    final SyncTaskModel task = SyncTaskModel(
      id: id,
      sourceName: source.name,
      payloadTypeName: payloadType.name,
      payload: payload,
      createdAtIso: _clock().toIso8601String(),
      statusName: SyncStatus.pending.name,
    );
    await _local.writeSync(task);
    return Result.success(task.toEntity());
  }

  @override
  Future<Result<List<SyncTaskEntity>>> syncNow() async {
    final List<SyncTaskModel> pending = _local
        .readSync()
        .where((SyncTaskModel m) => m.statusName == SyncStatus.pending.name)
        .toList(growable: false);
    final List<SyncTaskEntity> results = <SyncTaskEntity>[];
    for (final SyncTaskModel task in pending) {
      await _local.writeSync(
        SyncTaskModel(
          id: task.id,
          sourceName: task.sourceName,
          payloadTypeName: task.payloadTypeName,
          payload: task.payload,
          createdAtIso: task.createdAtIso,
          statusName: SyncStatus.syncing.name,
          attempts: task.attempts + 1,
          lastErrorMessage: task.lastErrorMessage,
        ),
      );
      try {
        final bool ok = await _remote.syncPayload(
          taskId: task.id,
          payload: task.payload,
        );
        final SyncTaskModel resolved = SyncTaskModel(
          id: task.id,
          sourceName: task.sourceName,
          payloadTypeName: task.payloadTypeName,
          payload: task.payload,
          createdAtIso: task.createdAtIso,
          statusName: ok ? SyncStatus.synced.name : SyncStatus.failed.name,
          attempts: task.attempts + 1,
          lastErrorMessage: ok ? null : 'Remote rejected payload',
        );
        await _local.writeSync(resolved);
        results.add(resolved.toEntity());
        if (ok) await _local.removeSync(task.id);
      } catch (e) {
        await _local.writeSync(
          SyncTaskModel(
            id: task.id,
            sourceName: task.sourceName,
            payloadTypeName: task.payloadTypeName,
            payload: task.payload,
            createdAtIso: task.createdAtIso,
            statusName: SyncStatus.failed.name,
            attempts: task.attempts + 1,
            lastErrorMessage: e.toString(),
          ),
        );
      }
    }
    return Result.success(results);
  }

  // ---- Cache control --------------------------------------------------------
  @override
  Future<Result<bool>> deleteOfflineItem(String id) async {
    final bool removed = await _local.removeItem(id);
    return Result.success(removed);
  }

  @override
  Future<Result<bool>> clearCache() async {
    await _local.clearSync();
    return Result.success(true);
  }

  @override
  Future<Result<bool>> deleteAllDownloads() async {
    await _local.clearItems();
    return Result.success(true);
  }

  // ---- Internal ticker ------------------------------------------------------
  void _ensureTicker() {
    if (_ticker != null && _ticker!.isActive) return;
    _ticker = Timer.periodic(const Duration(milliseconds: 600), (_) {
      _tick();
    });
  }

  void _stopTicker() {
    if (_ticker == null) return;
    if (_local.readDownloads().every((DownloadTaskModel m) =>
        m.statusName != DownloadStatus.downloading.name)) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  void _tick() {
    final math.Random rng = math.Random();
    final List<DownloadTaskModel> active = _local
        .readDownloads()
        .where((DownloadTaskModel m) =>
            m.statusName == DownloadStatus.downloading.name)
        .toList(growable: false);
    if (active.isEmpty) {
      _stopTicker();
      return;
    }
    for (final DownloadTaskModel task in active) {
      final int remaining = task.totalBytes - task.receivedBytes;
      if (remaining <= 0) {
        _local.writeDownload(_completedTask(task));
        _materialiseItem(task);
        continue;
      }
      final int delta = (_defaultKbPerTick * 1024 + rng.nextInt(64 * 1024))
          .clamp(1, remaining);
      final DownloadTaskModel advanced = DownloadTaskModel(
        id: task.id,
        contentId: task.contentId,
        title: task.title,
        contentTypeName: task.contentTypeName,
        totalBytes: task.totalBytes,
        receivedBytes: task.receivedBytes + delta,
        statusName: DownloadStatus.downloading.name,
        createdAtIso: task.createdAtIso,
      );
      _local.writeDownload(advanced);
      if (task.receivedBytes + delta >= task.totalBytes) {
        _local.writeDownload(_completedTask(task));
        _materialiseItem(task);
      }
    }
  }

  DownloadTaskModel _completedTask(DownloadTaskModel task) {
    return DownloadTaskModel(
      id: task.id,
      contentId: task.contentId,
      title: task.title,
      contentTypeName: task.contentTypeName,
      totalBytes: task.totalBytes,
      receivedBytes: task.totalBytes,
      statusName: DownloadStatus.completed.name,
      createdAtIso: task.createdAtIso,
      completedAtIso: _clock().toIso8601String(),
    );
  }

  void _materialiseItem(DownloadTaskModel task) {
    final OfflineContentType type = task.contentTypeName == 'questionSet'
        ? OfflineContentType.questionSet
        : task.contentTypeName == 'mockTest'
            ? OfflineContentType.mockTest
            : OfflineContentType.lesson;
    final OfflineItemModel item = OfflineItemModel(
      id: task.contentId,
      title: task.title,
      subtitle: '${type.label} · ${(task.totalBytes / (1024 * 1024)).round()}MB',
      contentTypeName: type.name,
      sizeBytes: task.totalBytes,
      downloadedAtIso: _clock().toIso8601String(),
      lastAccessedIso: _clock().toIso8601String(),
      thumbnailIconKey: type == OfflineContentType.lesson
          ? 'bookmarkLesson'
          : 'bookmarkQuestion',
      subjectTag: type == OfflineContentType.lesson ? 'General' : 'Mixed',
      itemCount: type == OfflineContentType.lesson ? 10 : 50,
    );
    _local.writeItem(item);
  }

  void dispose() {
    _ticker?.cancel();
  }
}