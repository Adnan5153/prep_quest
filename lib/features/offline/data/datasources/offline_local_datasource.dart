// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:hive/hive.dart';

import '../../../../core/cache/hive_manager.dart';
import '../../domain/enums/offline_content_type.dart';
import '../models/download_task_model.dart';
import '../models/offline_item_model.dart';
import '../models/sync_task_model.dart';

/// Hive-backed offline store.
///
/// All offline state lives here. Items, downloads, and pending sync
/// tasks each have their own typed [Box] so the on-disk format is
/// stable across app updates and survives uninstalls-of-data via the
/// platform documents directory.
///
/// Streams surface live updates to the UI layer; writes are routed
/// straight into the boxes and fan out a snapshot to subscribers.
class OfflineLocalDataSource {
  OfflineLocalDataSource({
    required HiveManager hive,
    DateTime Function()? clock,
  })  : _hive = hive,
        _clock = clock ?? DateTime.now {
    _bootstrap();
  }

  final HiveManager _hive;
  final DateTime Function() _clock;

  static const String itemsBoxName = 'offline_items_v1';
  static const String downloadsBoxName = 'offline_downloads_v1';
  static const String syncBoxName = 'offline_sync_v1';

  Box<OfflineItemModel>? _itemsBox;
  Box<DownloadTaskModel>? _downloadsBox;
  Box<SyncTaskModel>? _syncBox;

  final StreamController<List<OfflineItemModel>> _itemsStream =
      StreamController<List<OfflineItemModel>>.broadcast();
  final StreamController<List<DownloadTaskModel>> _downloadsStream =
      StreamController<List<DownloadTaskModel>>.broadcast();
  final StreamController<List<SyncTaskModel>> _syncStream =
      StreamController<List<SyncTaskModel>>.broadcast();

  Stream<List<OfflineItemModel>> watchItems() => _itemsStream.stream;
  Stream<List<DownloadTaskModel>> watchDownloads() =>
      _downloadsStream.stream;
  Stream<List<SyncTaskModel>> watchSync() => _syncStream.stream;

  /// Opens every box the datasource owns and seeds demo data the first
  /// time the app runs. Returns a future the caller may await before
  /// the first screen mounts.
  Future<void> ensureReady() async {
    await _bootstrap();
  }

  // ---- Items ---------------------------------------------------------------
  List<OfflineItemModel> readItems({OfflineContentType? filter}) {
    final Box<OfflineItemModel>? box = _itemsBox;
    if (box == null) return const <OfflineItemModel>[];
    final List<OfflineItemModel> all = box.values.toList(growable: false);
    if (filter == null) return all;
    return all
        .where((OfflineItemModel m) => m.contentTypeName == filter.name)
        .toList(growable: false);
  }

  OfflineItemModel? findItem(String id) => _itemsBox?.get(id);

  Future<void> writeItem(OfflineItemModel model) async {
    final Box<OfflineItemModel>? box = _itemsBox;
    if (box == null) return;
    await box.put(model.id, model);
    _emitItems();
  }

  Future<bool> removeItem(String id) async {
    final Box<OfflineItemModel>? box = _itemsBox;
    if (box == null) return false;
    final bool existed = box.containsKey(id);
    if (existed) {
      await box.delete(id);
      _emitItems();
    }
    return existed;
  }

  Future<void> clearItems() async {
    final Box<OfflineItemModel>? box = _itemsBox;
    if (box == null) return;
    await box.clear();
    _emitItems();
  }

  // ---- Downloads -----------------------------------------------------------
  List<DownloadTaskModel> readDownloads() =>
      _downloadsBox?.values.toList(growable: false) ??
      const <DownloadTaskModel>[];

  DownloadTaskModel? findDownload(String id) => _downloadsBox?.get(id);

  Future<void> writeDownload(DownloadTaskModel model) async {
    final Box<DownloadTaskModel>? box = _downloadsBox;
    if (box == null) return;
    await box.put(model.id, model);
    _emitDownloads();
  }

  Future<bool> removeDownload(String id) async {
    final Box<DownloadTaskModel>? box = _downloadsBox;
    if (box == null) return false;
    final bool existed = box.containsKey(id);
    if (existed) {
      await box.delete(id);
      _emitDownloads();
    }
    return existed;
  }

  // ---- Sync ----------------------------------------------------------------
  List<SyncTaskModel> readSync() =>
      _syncBox?.values.toList(growable: false) ??
      const <SyncTaskModel>[];

  SyncTaskModel? findSync(String id) => _syncBox?.get(id);

  Future<void> writeSync(SyncTaskModel model) async {
    final Box<SyncTaskModel>? box = _syncBox;
    if (box == null) return;
    await box.put(model.id, model);
    _emitSync();
  }

  Future<bool> removeSync(String id) async {
    final Box<SyncTaskModel>? box = _syncBox;
    if (box == null) return false;
    final bool existed = box.containsKey(id);
    if (existed) {
      await box.delete(id);
      _emitSync();
    }
    return existed;
  }

  Future<void> clearSync() async {
    final Box<SyncTaskModel>? box = _syncBox;
    if (box == null) return;
    await box.clear();
    _emitSync();
  }

  // ---- Bootstrap -----------------------------------------------------------
  Future<void> _bootstrap() async {
    if (_itemsBox != null && _downloadsBox != null && _syncBox != null) {
      return;
    }
    _itemsBox = await _hive.openBox<OfflineItemModel>(itemsBoxName);
    _downloadsBox = await _hive.openBox<DownloadTaskModel>(downloadsBoxName);
    _syncBox = await _hive.openBox<SyncTaskModel>(syncBoxName);

    final bool firstRun =
        _itemsBox!.isEmpty && _downloadsBox!.isEmpty && _syncBox!.isEmpty;
    if (firstRun) {
      await _seedDemoData();
    }

    _emitItems();
    _emitDownloads();
    _emitSync();
  }

  Future<void> _seedDemoData() async {
    final DateTime now = _clock();
    OfflineItemModel lesson(String id, String title, String subject, int mb,
        {int itemCount = 12}) {
      final DateTime downloaded = now.subtract(const Duration(days: 2));
      return OfflineItemModel(
        id: id,
        title: title,
        subtitle: '$subject · $itemCount lessons · ${mb}MB',
        contentTypeName: OfflineContentType.lesson.name,
        sizeBytes: mb * 1024 * 1024,
        downloadedAtIso: downloaded.toIso8601String(),
        lastAccessedIso: downloaded.toIso8601String(),
        thumbnailIconKey: 'bookmarkLesson',
        subjectTag: subject,
        itemCount: itemCount,
      );
    }

    OfflineItemModel questions(String id, String title, String subject,
        int mb, int count) {
      final DateTime downloaded = now.subtract(const Duration(days: 1));
      return OfflineItemModel(
        id: id,
        title: title,
        subtitle: '$subject · $count questions · ${mb}MB',
        contentTypeName: OfflineContentType.questionSet.name,
        sizeBytes: mb * 1024 * 1024,
        downloadedAtIso: downloaded.toIso8601String(),
        lastAccessedIso: downloaded.toIso8601String(),
        thumbnailIconKey: 'bookmarkQuestion',
        subjectTag: subject,
        itemCount: count,
      );
    }

    final List<OfflineItemModel> seeds = <OfflineItemModel>[
      lesson('lesson-en-tenses', 'English Tenses — Complete Pack', 'English',
          24, itemCount: 18),
      lesson('lesson-math-percentage', 'Percentage shortcuts for BCS',
          'Mathematics', 18, itemCount: 14),
      lesson('lesson-bangla-sondhi', 'সন্ধি বিচ্ছেদ — বাংলা', 'Bangla', 16,
          itemCount: 11),
      questions('qs-bcs-2024', 'BCS Preliminary 2024 — Model Set', 'Mixed', 12,
          200),
      questions('qs-bank-aptitude', 'Bank Aptitude — Quantitative', 'Bank', 8,
          120),
    ];
    for (final OfflineItemModel m in seeds) {
      await _itemsBox!.put(m.id, m);
    }

    final List<SyncTaskModel> syncSeeds = <SyncTaskModel>[
      SyncTaskModel(
        id: 'sync-demo-1',
        sourceName: 'quiz',
        payloadTypeName: 'quizAttempt',
        payload: const <String, dynamic>{
          'quiz_id': 'qs-bcs-2024',
          'score': 78,
          'time_taken_seconds': 1820,
        },
        createdAtIso: now
            .subtract(const Duration(minutes: 18))
            .toIso8601String(),
        statusName: 'pending',
      ),
      SyncTaskModel(
        id: 'sync-demo-2',
        sourceName: 'gamification',
        payloadTypeName: 'xpEvent',
        payload: const <String, dynamic>{
          'amount': 35,
          'reason': 'lesson_completed',
        },
        createdAtIso: now
            .subtract(const Duration(minutes: 12))
            .toIso8601String(),
        statusName: 'pending',
      ),
      SyncTaskModel(
        id: 'sync-demo-3',
        sourceName: 'bookmarks',
        payloadTypeName: 'bookmark',
        payload: const <String, dynamic>{
          'item_id': 'lesson-math-percentage',
          'action': 'add',
        },
        createdAtIso: now
            .subtract(const Duration(minutes: 6))
            .toIso8601String(),
        statusName: 'pending',
      ),
    ];
    for (final SyncTaskModel m in syncSeeds) {
      await _syncBox!.put(m.id, m);
    }
  }

  // ---- Stream fan-out ------------------------------------------------------
  void _emitItems() {
    final Box<OfflineItemModel>? box = _itemsBox;
    if (box == null) return;
    _itemsStream.add(box.values.toList(growable: false));
  }

  void _emitDownloads() {
    final Box<DownloadTaskModel>? box = _downloadsBox;
    if (box == null) return;
    _downloadsStream.add(box.values.toList(growable: false));
  }

  void _emitSync() {
    final Box<SyncTaskModel>? box = _syncBox;
    if (box == null) return;
    _syncStream.add(box.values.toList(growable: false));
  }

  void dispose() {
    _itemsStream.close();
    _downloadsStream.close();
    _syncStream.close();
  }
}