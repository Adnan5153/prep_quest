import '../../domain/entities/offline_item_entity.dart';
import '../../domain/enums/offline_content_type.dart';

class OfflineItemModel {
  const OfflineItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.contentTypeName,
    required this.sizeBytes,
    required this.downloadedAtIso,
    required this.lastAccessedIso,
    this.thumbnailIconKey,
    this.subjectTag,
    this.itemCount = 0,
  });

  factory OfflineItemModel.fromMap(Map<String, dynamic> map) {
    return OfflineItemModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: (map['subtitle'] as String?) ?? '',
      contentTypeName: map['content_type'] as String? ?? 'lesson',
      sizeBytes: (map['size_bytes'] as num?)?.toInt() ?? 0,
      downloadedAtIso: (map['downloaded_at_iso'] as String?) ?? '',
      lastAccessedIso: (map['last_accessed_iso'] as String?) ?? '',
      thumbnailIconKey: map['thumbnail_icon_key'] as String?,
      subjectTag: map['subject_tag'] as String?,
      itemCount: (map['item_count'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String contentTypeName;
  final int sizeBytes;
  final String downloadedAtIso;
  final String lastAccessedIso;
  final String? thumbnailIconKey;
  final String? subjectTag;
  final int itemCount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content_type': contentTypeName,
      'size_bytes': sizeBytes,
      'downloaded_at_iso': downloadedAtIso,
      'last_accessed_iso': lastAccessedIso,
      'thumbnail_icon_key': thumbnailIconKey,
      'subject_tag': subjectTag,
      'item_count': itemCount,
    };
  }

  OfflineItemEntity toEntity() {
    return OfflineItemEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      contentType: _parseType(contentTypeName),
      sizeBytes: sizeBytes,
      downloadedAtIso: downloadedAtIso,
      lastAccessedIso: lastAccessedIso,
      thumbnailIconKey: thumbnailIconKey,
      subjectTag: subjectTag,
      itemCount: itemCount,
    );
  }

  static OfflineItemEntity entityFromMap(Map<String, dynamic> map) =>
      OfflineItemModel.fromMap(map).toEntity();

  static OfflineContentType _parseType(String raw) {
    return OfflineContentType.values.firstWhere(
      (OfflineContentType t) => t.name == raw,
      orElse: () => OfflineContentType.lesson,
    );
  }
}