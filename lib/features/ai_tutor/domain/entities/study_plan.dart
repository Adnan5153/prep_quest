import 'package:flutter/foundation.dart';

/// A single study task inside a [StudyPlan].
@immutable
class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.kind,
    this.description,
    this.relatedTopic,
    this.completed = false,
  });

  final String id;
  final String title;
  final String? description;
  final int estimatedMinutes;
  final StudyTaskKind kind;
  final String? relatedTopic;
  final bool completed;

  StudyTask copyWith({
    String? id,
    String? title,
    String? description,
    int? estimatedMinutes,
    StudyTaskKind? kind,
    String? relatedTopic,
    bool? completed,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      kind: kind ?? this.kind,
      relatedTopic: relatedTopic ?? this.relatedTopic,
      completed: completed ?? this.completed,
    );
  }
}

enum StudyTaskKind {
  lesson,
  practice,
  review,
  mockTest,
  flashcards,
  rest,
}

/// A multi-day study plan with one or more [StudyTask]s per day.
@immutable
class StudyPlan {
  const StudyPlan({
    required this.id,
    required this.title,
    required this.subject,
    required this.days,
    required this.totalMinutes,
    required this.createdAt,
    this.subtitle,
    this.description,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String subject;
  final List<StudyDay> days;
  final int totalMinutes;
  final DateTime createdAt;

  factory StudyPlan.day({
    required String id,
    required String title,
    required String subject,
    required String dayTitle,
    required List<StudyTask> tasks,
    required DateTime createdAt,
    String? subtitle,
    String? description,
  }) {
    final int total =
        tasks.fold<int>(0, (int sum, StudyTask t) => sum + t.estimatedMinutes);
    return StudyPlan(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      subject: subject,
      days: <StudyDay>[
        StudyDay(
          id: '$id-day-0',
          dayLabel: dayTitle,
          tasks: tasks,
        ),
      ],
      totalMinutes: total,
      createdAt: createdAt,
    );
  }
}

@immutable
class StudyDay {
  const StudyDay({
    required this.id,
    required this.dayLabel,
    required this.tasks,
  });

  final String id;
  final String dayLabel;
  final List<StudyTask> tasks;

  int get estimatedMinutes => tasks.fold<int>(
        0,
        (int sum, StudyTask t) => sum + t.estimatedMinutes,
      );
}