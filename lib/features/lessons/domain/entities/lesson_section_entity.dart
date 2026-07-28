import 'package:flutter/foundation.dart';

enum LessonSectionKind { introduction, concept, explanation, practice, tip, summary }

@immutable
class LessonSectionEntity {
  const LessonSectionEntity({
    required this.id,
    required this.title,
    required this.body,
    this.kind = LessonSectionKind.concept,
    this.bullets = const <String>[],
    this.callout,
    this.isCompleted = false,
    this.estimatedMinutes = 2,
  });

  final String id;
  final String title;
  final String body;
  final LessonSectionKind kind;
  final List<String> bullets;
  final String? callout;
  final bool isCompleted;
  final int estimatedMinutes;

  LessonSectionEntity copyWith({
    bool? isCompleted,
  }) {
    return LessonSectionEntity(
      id: id,
      title: title,
      body: body,
      kind: kind,
      bullets: bullets,
      callout: callout,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedMinutes: estimatedMinutes,
    );
  }
}