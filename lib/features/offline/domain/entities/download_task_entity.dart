import 'package:flutter/foundation.dart';

import '../enums/offline_content_type.dart';

/// A single in-flight or queued download. The UI uses this to render
/// progress, pause/resume, and cancel.
@immutable
class DownloadTaskEntity {
  const DownloadTaskEntity({
    required this.id,
    required this.contentId,
    required this.title,
    required this.contentType,
    required this.totalBytes,
    required this.receivedBytes,
    required this.status,
    required this.createdAtIso,
    this.completedAtIso,
    this.errorMessage,
  });

  final String id;
  final String contentId;
  final String title;
  final OfflineContentType contentType;
  final int totalBytes;
  final int receivedBytes;
  final DownloadStatus status;
  final String createdAtIso;
  final String? completedAtIso;
  final String? errorMessage;

  double get progress {
    if (totalBytes == 0) return 0;
    final double raw = receivedBytes / totalBytes;
    if (raw.isNaN || raw.isInfinite) return 0;
    return raw.clamp(0.0, 1.0);
  }

  bool get isComplete => status == DownloadStatus.completed;
  bool get isPaused => status == DownloadStatus.paused;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;
  bool get isActive => status.isActive && !isPaused;

  DownloadTaskEntity copyWith({
    int? receivedBytes,
    int? totalBytes,
    DownloadStatus? status,
    String? completedAtIso,
    String? errorMessage,
  }) {
    return DownloadTaskEntity(
      id: id,
      contentId: contentId,
      title: title,
      contentType: contentType,
      totalBytes: totalBytes ?? this.totalBytes,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      status: status ?? this.status,
      createdAtIso: createdAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}