import '../../domain/entities/highlight_entity.dart';
import '../../domain/enums/note_color.dart';

/// JSON-ready shape for [HighlightEntity].
class HighlightModel {
  const HighlightModel({
    required this.id,
    required this.text,
    required this.sourceTitle,
    required this.sourceFeature,
    required this.routeName,
    required this.itemId,
    required this.color,
    required this.createdAtIso,
    this.subtitle,
    this.iconKey,
    this.tags = const <String>[],
    this.routeParams = const <String, String>{},
  });

  factory HighlightModel.fromEntity(HighlightEntity entity) {
    return HighlightModel(
      id: entity.id,
      text: entity.text,
      sourceTitle: entity.sourceTitle,
      sourceFeature: entity.sourceFeature,
      routeName: entity.routeName,
      itemId: entity.itemId,
      subtitle: entity.subtitle,
      iconKey: entity.iconKey,
      color: entity.color is NoteColor ? entity.color as NoteColor : NoteColor.defaultColor,
      createdAtIso: entity.createdAtIso,
      tags: entity.tags,
      routeParams: entity.routeParams,
    );
  }

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: (json['id'] as String?) ?? '',
      text: (json['text'] as String?) ?? '',
      sourceTitle: (json['sourceTitle'] as String?) ?? '',
      sourceFeature: (json['sourceFeature'] as String?) ?? '',
      routeName: (json['routeName'] as String?) ?? '',
      itemId: (json['itemId'] as String?) ?? '',
      subtitle: json['subtitle'] as String?,
      iconKey: json['iconKey'] as String?,
      color: _parseColor(json['color'] as String?),
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      routeParams: ((json['routeParams'] as Map<String, dynamic>?) ??
              const <String, dynamic>{})
          .map((String k, dynamic v) => MapEntry<String, String>(k, '$v')),
    );
  }

  final String id;
  final String text;
  final String sourceTitle;
  final String sourceFeature;
  final String routeName;
  final String itemId;
  final String? subtitle;
  final String? iconKey;
  final NoteColor color;
  final String createdAtIso;
  final List<String> tags;
  final Map<String, String> routeParams;

  HighlightEntity toEntity() => HighlightEntity(
        id: id,
        text: text,
        sourceTitle: sourceTitle,
        sourceFeature: sourceFeature,
        routeName: routeName,
        itemId: itemId,
        subtitle: subtitle,
        iconKey: iconKey,
        color: color,
        createdAtIso: createdAtIso,
        tags: tags,
        routeParams: routeParams,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        'sourceTitle': sourceTitle,
        'sourceFeature': sourceFeature,
        'routeName': routeName,
        'itemId': itemId,
        'subtitle': subtitle,
        'iconKey': iconKey,
        'color': color.name,
        'createdAtIso': createdAtIso,
        'tags': tags,
        'routeParams': routeParams,
      };

  static NoteColor _parseColor(String? raw) {
    if (raw == 'default') return NoteColor.defaultColor;
    return NoteColor.values.firstWhere(
      (NoteColor c) => c.name == raw,
      orElse: () => NoteColor.defaultColor,
    );
  }
}
