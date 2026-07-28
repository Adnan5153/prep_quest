import 'package:flutter/foundation.dart';

import 'note_entity.dart';

/// A captured passage of text from another feature (lessons, AI Tutor).
///
/// On save the highlight is converted to a [NoteEntity] of type
/// [NoteType.highlight]; this class models the input payload before
/// that conversion.
@immutable
class HighlightEntity {
  const HighlightEntity({
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

  final String id;
  final String text;
  final String sourceTitle;
  final String sourceFeature;
  final String routeName;
  final String itemId;
  final String? subtitle;
  final String? iconKey;
  final dynamic color;
  final String createdAtIso;
  final List<String> tags;
  final Map<String, String> routeParams;

  HighlightEntity copyWith({
    String? id,
    String? text,
    String? sourceTitle,
    String? sourceFeature,
    String? routeName,
    String? itemId,
    String? subtitle,
    String? iconKey,
    dynamic color,
    String? createdAtIso,
    List<String>? tags,
    Map<String, String>? routeParams,
  }) {
    return HighlightEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      sourceFeature: sourceFeature ?? this.sourceFeature,
      routeName: routeName ?? this.routeName,
      itemId: itemId ?? this.itemId,
      subtitle: subtitle ?? this.subtitle,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      tags: tags ?? this.tags,
      routeParams: routeParams ?? this.routeParams,
    );
  }
}