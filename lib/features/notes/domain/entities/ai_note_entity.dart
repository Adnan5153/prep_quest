import 'package:flutter/foundation.dart';

import '../enums/note_category.dart';
import '../enums/note_color.dart';
import '../enums/note_type.dart';
import 'note_entity.dart';

/// Input payload for saving an AI Tutor explanation as a note.
@immutable
class AiNoteEntity {
  const AiNoteEntity({
    required this.id,
    required this.prompt,
    required this.response,
    required this.routeName,
    required this.itemId,
    required this.createdAtIso,
    this.title,
    this.tags = const <String>[],
    this.color,
    this.category,
    this.iconKey,
    this.routeParams = const <String, String>{},
  });

  final String id;
  final String prompt;
  final String response;
  final String? title;
  final String routeName;
  final String itemId;
  final String? iconKey;
  final dynamic color;
  final NoteCategory? category;
  final String createdAtIso;
  final List<String> tags;
  final Map<String, String> routeParams;

  AiNoteEntity copyWith({
    String? id,
    String? prompt,
    String? response,
    String? title,
    String? routeName,
    String? itemId,
    String? iconKey,
    dynamic color,
    NoteCategory? category,
    String? createdAtIso,
    List<String>? tags,
    Map<String, String>? routeParams,
  }) {
    return AiNoteEntity(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      title: title ?? this.title,
      routeName: routeName ?? this.routeName,
      itemId: itemId ?? this.itemId,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      category: category ?? this.category,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      tags: tags ?? this.tags,
      routeParams: routeParams ?? this.routeParams,
    );
  }

  NoteEntity toNoteEntity() {
    final DateTime now = DateTime.now();
    final NoteEntity note = NoteEntity(
      id: id,
      title: title ?? prompt,
      content: response,
      type: NoteType.ai,
      category: category ?? NoteCategory.ai,
      color: color is NoteColor ? color as NoteColor : NoteColor.defaultColor,
      isPinned: false,
      isFavorite: false,
      tags: tags,
      attachments: <NoteAttachmentEntity>[
        NoteAttachmentEntity(
          kind: 'aiResponse',
          itemId: itemId,
          title: title ?? prompt,
          routeName: routeName,
          iconKey: iconKey,
        ),
      ],
      createdAtIso: createdAtIso,
      updatedAtIso: now.toIso8601String(),
      preview: response.length <= 160
          ? response
          : '${response.substring(0, 160).trimRight()}…',
    );
    return note;
  }
}