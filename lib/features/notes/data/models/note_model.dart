import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';
import '../../domain/enums/note_type.dart';

/// JSON-ready persistence shape for [NoteEntity].
class NoteModel {
  const NoteModel({
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

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      preview: entity.preview,
      type: entity.type,
      category: entity.category,
      color: entity.color,
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      tags: entity.tags,
      attachments: entity.attachments,
      createdAtIso: entity.createdAtIso,
      updatedAtIso: entity.updatedAtIso,
      sourceFeature: entity.sourceFeature,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      content: (json['content'] as String?) ?? '',
      preview: json['preview'] as String?,
      type: _parseType(json['type'] as String?),
      category: _parseCategory(json['category'] as String?),
      color: _parseColor(json['color'] as String?),
      isPinned: (json['isPinned'] as bool?) ?? false,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      attachments: ((json['attachments'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(_attachmentFromJson)
          .toList(growable: false),
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      updatedAtIso: (json['updatedAtIso'] as String?) ?? '',
      sourceFeature: (json['sourceFeature'] as String?) ?? 'notes',
    );
  }

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
  final String sourceFeature;

  NoteEntity toEntity() => NoteEntity(
        id: id,
        title: title,
        content: content,
        preview: preview,
        type: type,
        category: category,
        color: color,
        isPinned: isPinned,
        isFavorite: isFavorite,
        tags: tags,
        attachments: attachments,
        createdAtIso: createdAtIso,
        updatedAtIso: updatedAtIso,
        sourceFeature: sourceFeature,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'preview': preview,
        'type': type.name,
        'category': category.name,
        'color': color.name,
        'isPinned': isPinned,
        'isFavorite': isFavorite,
        'tags': tags,
        'attachments':
            attachments.map(_attachmentToJson).toList(growable: false),
        'createdAtIso': createdAtIso,
        'updatedAtIso': updatedAtIso,
        'sourceFeature': sourceFeature,
      };

  NoteModel copyWith({
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
    return NoteModel(
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

  static NoteAttachmentEntity _attachmentFromJson(Map<String, dynamic> json) {
    return NoteAttachmentEntity(
      kind: (json['kind'] as String?) ?? '',
      itemId: (json['itemId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      routeName: json['routeName'] as String?,
      subtitle: json['subtitle'] as String?,
      iconKey: json['iconKey'] as String?,
    );
  }

  static Map<String, dynamic> _attachmentToJson(NoteAttachmentEntity a) {
    return <String, dynamic>{
      'kind': a.kind,
      'itemId': a.itemId,
      'title': a.title,
      'routeName': a.routeName,
      'subtitle': a.subtitle,
      'iconKey': a.iconKey,
    };
  }

  static NoteType _parseType(String? raw) {
    return NoteType.values.firstWhere(
      (NoteType t) => t.name == raw,
      orElse: () => NoteType.personal,
    );
  }

  static NoteCategory _parseCategory(String? raw) {
    return NoteCategory.values.firstWhere(
      (NoteCategory c) => c.name == raw,
      orElse: () => NoteCategory.personal,
    );
  }

  static NoteColor _parseColor(String? raw) {
    if (raw == 'default') return NoteColor.defaultColor;
    return NoteColor.values.firstWhere(
      (NoteColor c) => c.name == raw,
      orElse: () => NoteColor.defaultColor,
    );
  }
}
