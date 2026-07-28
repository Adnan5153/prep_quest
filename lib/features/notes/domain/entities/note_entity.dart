import 'package:flutter/foundation.dart';

import '../enums/note_category.dart';
import '../enums/note_color.dart';
import '../enums/note_type.dart';

/// Attachment pointing at another domain entity.
@immutable
class NoteAttachmentEntity {
  const NoteAttachmentEntity({
    required this.kind,
    required this.itemId,
    required this.title,
    this.routeName,
    this.subtitle,
    this.iconKey,
  });

  final String kind;
  final String itemId;
  final String title;
  final String? routeName;
  final String? subtitle;
  final String? iconKey;

  Map<String, String> get routeParams {
    final Map<String, String> params = <String, String>{
      'itemId': itemId,
      'kind': kind,
    };
    if (routeName != null) {
      params['route'] = routeName!;
    }
    return params;
  }

  NoteAttachmentEntity copyWith({
    String? kind,
    String? itemId,
    String? title,
    String? routeName,
    String? subtitle,
    String? iconKey,
  }) {
    return NoteAttachmentEntity(
      kind: kind ?? this.kind,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      routeName: routeName ?? this.routeName,
      subtitle: subtitle ?? this.subtitle,
      iconKey: iconKey ?? this.iconKey,
    );
  }
}

/// User-authored note spanning personal thoughts, lesson highlights,
/// and AI Tutor explanations.
@immutable
class NoteEntity {
  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.category,
    required this.color,
    required this.isPinned,
    required this.isFavorite,
    required this.tags,
    required this.attachments,
    required this.createdAtIso,
    required this.updatedAtIso,
    this.preview,
    this.sourceFeature = 'notes',
  });

  final String id;
  final String title;
  final String content;
  final String? preview;
  final NoteType type;
  final NoteCategory category;
  final NoteColor color;

  final bool isPinned;
  final bool isFavorite;

  final List<String> tags;
  final List<NoteAttachmentEntity> attachments;

  final String createdAtIso;
  final String updatedAtIso;

  /// Identifies the feature that owns this note. Currently always
  /// `notes` but reserved for future cross-feature attribution.
  final String sourceFeature;

  String get resolvedPreview {
    if (preview != null && preview!.trim().isNotEmpty) return preview!;
    if (content.length <= 160) return content;
    return '${content.substring(0, 160).trimRight()}…';
  }

  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? preview,
    bool clearPreview = false,
    NoteType? type,
    NoteCategory? category,
    NoteColor? color,
    bool? isPinned,
    bool? isFavorite,
    List<String>? tags,
    List<NoteAttachmentEntity>? attachments,
    String? createdAtIso,
    String? updatedAtIso,
    String? sourceFeature,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      preview: clearPreview ? null : (preview ?? this.preview),
      type: type ?? this.type,
      category: category ?? this.category,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
      sourceFeature: sourceFeature ?? this.sourceFeature,
    );
  }
}