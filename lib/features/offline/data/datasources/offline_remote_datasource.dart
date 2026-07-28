import 'dart:async';

import '../models/download_task_model.dart';
import '../models/offline_item_model.dart';

/// Firestore-style remote datasource. The current scaffold ships
/// without Firebase wired in, so this returns deterministic mock
/// payloads. Replace the body with the Firestore client when the
/// backend integration lands.
class OfflineRemoteDataSource {
  OfflineRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 220);

  final Duration _latency;

  Future<OfflineItemModel> fetchManifest(String contentId) async {
    await Future<void>.delayed(_latency);
    final int megabytes = (contentId.length * 3) + 12;
    return OfflineItemModel(
      id: contentId,
      title: 'Manifest · $contentId',
      subtitle: 'Remote manifest payload',
      contentTypeName: 'lesson',
      sizeBytes: megabytes * 1024 * 1024,
      downloadedAtIso: DateTime.now().toIso8601String(),
      lastAccessedIso: DateTime.now().toIso8601String(),
    );
  }

  Future<List<DownloadTaskModel>> fetchActiveDownloads() async {
    await Future<void>.delayed(_latency);
    return const <DownloadTaskModel>[];
  }

  Future<bool> syncPayload({
    required String taskId,
    required Map<String, dynamic> payload,
  }) async {
    await Future<void>.delayed(_latency);
    // Mock: every payload succeeds.
    return true;
  }
}