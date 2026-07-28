import '../../domain/entities/download_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';

class DownloadTaskModel {
  const DownloadTaskModel({
    required this.id,
    required this.contentId,
    required this.title,
    required this.contentTypeName,
    required this.totalBytes,
    required this.receivedBytes,
    required this.statusName,
    required this.createdAtIso,
    this.completedAtIso,
    this.errorMessage,
  });

  factory DownloadTaskModel.fromMap(Map<String, dynamic> map) {
    return DownloadTaskModel(
      id: map['id'] as String,
      contentId: map['content_id'] as String,
      title: map['title'] as String,
      contentTypeName: map['content_type'] as String? ?? 'lesson',
      totalBytes: (map['total_bytes'] as num?)?.toInt() ?? 0,
      receivedBytes: (map['received_bytes'] as num?)?.toInt() ?? 0,
      statusName: map['status'] as String? ?? 'queued',
      createdAtIso: (map['created_at_iso'] as String?) ?? '',
      completedAtIso: map['completed_at_iso'] as String?,
      errorMessage: map['error_message'] as String?,
    );
  }

  final String id;
  final String contentId;
  final String title;
  final String contentTypeName;
  final int totalBytes;
  final int receivedBytes;
  final String statusName;
  final String createdAtIso;
  final String? completedAtIso;
  final String? errorMessage;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content_id': contentId,
      'title': title,
      'content_type': contentTypeName,
      'total_bytes': totalBytes,
      'received_bytes': receivedBytes,
      'status': statusName,
      'created_at_iso': createdAtIso,
      'completed_at_iso': completedAtIso,
      'error_message': errorMessage,
    };
  }

  DownloadTaskEntity toEntity() {
    return DownloadTaskEntity(
      id: id,
      contentId: contentId,
      title: title,
      contentType: _parseType(contentTypeName),
      totalBytes: totalBytes,
      receivedBytes: receivedBytes,
      status: _parseStatus(statusName),
      createdAtIso: createdAtIso,
      completedAtIso: completedAtIso,
      errorMessage: errorMessage,
    );
  }

  static OfflineContentType _parseType(String raw) {
    return OfflineContentType.values.firstWhere(
      (OfflineContentType t) => t.name == raw,
      orElse: () => OfflineContentType.lesson,
    );
  }

  static DownloadStatus _parseStatus(String raw) {
    return DownloadStatus.values.firstWhere(
      (DownloadStatus s) => s.name == raw,
      orElse: () => DownloadStatus.queued,
    );
  }
}