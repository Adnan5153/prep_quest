import 'package:flutter/foundation.dart';

@immutable
class LessonExampleEntity {
  const LessonExampleEntity({
    required this.id,
    required this.title,
    required this.prompt,
    required this.steps,
    required this.answer,
    this.explanation,
  });

  final String id;
  final String title;
  final String prompt;
  final List<String> steps;
  final String answer;
  final String? explanation;
}