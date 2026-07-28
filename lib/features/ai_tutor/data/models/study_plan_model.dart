import '../../domain/entities/study_plan.dart';

class StudyTaskModel {
  const StudyTaskModel({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.kindId,
    this.description,
    this.relatedTopic,
    this.completed = false,
  });

  final String id;
  final String title;
  final String? description;
  final int estimatedMinutes;
  final String kindId;
  final String? relatedTopic;
  final bool completed;

  StudyTask toEntity() {
    return StudyTask(
      id: id,
      title: title,
      description: description,
      estimatedMinutes: estimatedMinutes,
      kind: _kindFromId(kindId),
      relatedTopic: relatedTopic,
      completed: completed,
    );
  }

  static StudyTaskKind _kindFromId(String id) {
    for (final StudyTaskKind k in StudyTaskKind.values) {
      if (k.name == id) return k;
    }
    return StudyTaskKind.practice;
  }
}

class StudyDayModel {
  const StudyDayModel({
    required this.id,
    required this.dayLabel,
    required this.tasks,
  });

  final String id;
  final String dayLabel;
  final List<StudyTaskModel> tasks;

  StudyDay toEntity() {
    return StudyDay(
      id: id,
      dayLabel: dayLabel,
      tasks: tasks
          .map((StudyTaskModel t) => t.toEntity())
          .toList(growable: false),
    );
  }
}

class StudyPlanModel {
  const StudyPlanModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.days,
    required this.totalMinutes,
    required this.createdAtIso,
    this.subtitle,
    this.description,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String subject;
  final List<StudyDayModel> days;
  final int totalMinutes;
  final String createdAtIso;

  StudyPlan toEntity() {
    return StudyPlan(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      subject: subject,
      days: days
          .map((StudyDayModel d) => d.toEntity())
          .toList(growable: false),
      totalMinutes: totalMinutes,
      createdAt: DateTime.parse(createdAtIso),
    );
  }
}