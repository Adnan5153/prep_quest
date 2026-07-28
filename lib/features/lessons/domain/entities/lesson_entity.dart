import 'package:flutter/foundation.dart';

import 'lesson_example_entity.dart';
import 'lesson_section_entity.dart';
import 'lesson_summary_entity.dart';

/// Top-level lesson domain entity. Flutter-agnostic and persistence-friendly.
@immutable
class LessonEntity {
  const LessonEntity({
    required this.id,
    required this.subject,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.sections,
    required this.examples,
    required this.summarySection,
    required this.estimatedReadingMinutes,
    required this.difficulty,
    required this.tags,
    required this.rewardXp,
    required this.rewardCoins,
    this.requiresLevel = 1,
    this.isPremium = false,
    this.prerequisiteLessonIds = const <String>[],
  });

  final String id;
  final String subject;
  final String title;
  final String subtitle;
  final String summary;
  final List<LessonSectionEntity> sections;
  final List<LessonExampleEntity> examples;
  final LessonSummaryEntity summarySection;
  final int estimatedReadingMinutes;
  final String difficulty;
  final List<String> tags;
  final int rewardXp;
  final int rewardCoins;
  final int requiresLevel;
  final bool isPremium;
  final List<String> prerequisiteLessonIds;

  double get sectionCompletionRatio {
    if (sections.isEmpty) return 0;
    final int completed = sections
        .where((LessonSectionEntity s) => s.isCompleted)
        .length;
    return completed / sections.length;
  }
}