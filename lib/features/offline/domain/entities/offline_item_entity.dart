import 'package:flutter/foundation.dart';

import '../enums/offline_content_type.dart';

/// A discrete unit of content that can be downloaded for offline use.
@immutable
class OfflineItemEntity {
  const OfflineItemEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.contentType,
    required this.sizeBytes,
    required this.downloadedAtIso,
    required this.lastAccessedIso,
    this.thumbnailIconKey,
    this.subjectTag,
    this.itemCount = 0,
  });

  final String id;
  final String title;
  final String subtitle;
  final OfflineContentType contentType;
  final int sizeBytes;
  final String downloadedAtIso;
  final String lastAccessedIso;
  final String? thumbnailIconKey;
  final String? subjectTag;
  final int itemCount;

  OfflineItemEntity copyWith({
    String? title,
    String? subtitle,
    int? sizeBytes,
    String? downloadedAtIso,
    String? lastAccessedIso,
    String? thumbnailIconKey,
    String? subjectTag,
    int? itemCount,
  }) {
    return OfflineItemEntity(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      contentType: contentType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      downloadedAtIso: downloadedAtIso ?? this.downloadedAtIso,
      lastAccessedIso: lastAccessedIso ?? this.lastAccessedIso,
      thumbnailIconKey: thumbnailIconKey ?? this.thumbnailIconKey,
      subjectTag: subjectTag ?? this.subjectTag,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}