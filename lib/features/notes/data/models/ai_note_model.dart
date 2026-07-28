import '../../domain/entities/ai_note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';

/// JSON-ready shape for [AiNoteEntity].
class AiNoteModel {
  const AiNoteModel({
    required this.id,
    required this.prompt,
    required this.response,
    required this.routeName,
    required this.itemId,
    required this.createdAtIso,
    this.title,
    this.iconKey,
    this.color = NoteColor.defaultColor,
    this.category,
    this.tags = const <String>[],
    this.routeParams = const <String, String>{},
  });

  factory AiNoteModel.fromEntity(AiNoteEntity entity) {
    return AiNoteModel(
      id: entity.id,
      prompt: entity.prompt,
      response: entity.response,
      title: entity.title,
      routeName: entity.routeName,
      itemId: entity.itemId,
      iconKey: entity.iconKey,
      color: entity.color is NoteColor ? entity.color as NoteColor : NoteColor.defaultColor,
      category: entity.category,
      createdAtIso: entity.createdAtIso,
      tags: entity.tags,
      routeParams: entity.routeParams,
    );
  }

  factory AiNoteModel.fromJson(Map<String, dynamic> json) {
    return AiNoteModel(
      id: (json['id'] as String?) ?? '',
      prompt: (json['prompt'] as String?) ?? '',
      response: (json['response'] as String?) ?? '',
      title: json['title'] as String?,
      routeName: (json['routeName'] as String?) ?? '',
      itemId: (json['itemId'] as String?) ?? '',
      iconKey: json['iconKey'] as String?,
      color: _parseColor(json['color'] as String?),
      category: _parseCategory(json['category'] as String?),
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      routeParams: ((json['routeParams'] as Map<String, dynamic>?) ??
              const <String, dynamic>{})
          .map((String k, dynamic v) => MapEntry<String, String>(k, '$v')),
    );
  }

  final String id;
  final String prompt;
  final String response;
  final String? title;
  final String routeName;
  final String itemId;
  final String? iconKey;
  final NoteColor color;
  final NoteCategory? category;
  final String createdAtIso;
  final List<String> tags;
  final Map<String, String> routeParams;

  AiNoteEntity toEntity() => AiNoteEntity(
        id: id,
        prompt: prompt,
        response: response,
        title: title,
        routeName: routeName,
        itemId: itemId,
        iconKey: iconKey,
        color: color,
        category: category,
        createdAtIso: createdAtIso,
        tags: tags,
        routeParams: routeParams,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'prompt': prompt,
        'response': response,
        'title': title,
        'routeName': routeName,
        'itemId': itemId,
        'iconKey': iconKey,
        'color': color.name,
        'category': category?.name,
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

  static NoteCategory? _parseCategory(String? raw) {
    if (raw == null) return null;
    return NoteCategory.values.firstWhere(
      (NoteCategory c) => c.name == raw,
      orElse: () => NoteCategory.ai,
    );
  }
}
