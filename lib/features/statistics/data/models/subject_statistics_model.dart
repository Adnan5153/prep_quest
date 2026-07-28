import '../../domain/entities/subject_statistics_entity.dart';

class SubjectStatisticsModel {
  const SubjectStatisticsModel({
    required this.subjectId,
    required this.subjectName,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.skipped,
    required this.accuracyPercent,
    required this.averageSecondsPerQuestion,
    required this.totalMinutes,
    required this.xpEarned,
    required this.weakestTopicId,
    required this.weakestTopicName,
    required this.weakestTopicAccuracy,
    required this.achievementBadgeId,
  });

  final String subjectId;
  final String subjectName;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int skipped;
  final int accuracyPercent;
  final int averageSecondsPerQuestion;
  final int totalMinutes;
  final int xpEarned;
  final String? weakestTopicId;
  final String? weakestTopicName;
  final int? weakestTopicAccuracy;
  final String? achievementBadgeId;

  SubjectStatisticsEntity toEntity({bool isPriority = false}) {
    return SubjectStatisticsEntity(
      subjectId: subjectId,
      subjectName: subjectName,
      totalQuestions: totalQuestions,
      correct: correct,
      incorrect: incorrect,
      skipped: skipped,
      accuracyPercent: accuracyPercent,
      averageSecondsPerQuestion: averageSecondsPerQuestion,
      totalMinutes: totalMinutes,
      xpEarned: xpEarned,
      weakestTopicId: weakestTopicId,
      weakestTopicName: weakestTopicName,
      weakestTopicAccuracy: weakestTopicAccuracy,
      isPriority: isPriority,
      achievementBadgeId: achievementBadgeId,
    );
  }

  factory SubjectStatisticsModel.fromEntity(SubjectStatisticsEntity entity) {
    return SubjectStatisticsModel(
      subjectId: entity.subjectId,
      subjectName: entity.subjectName,
      totalQuestions: entity.totalQuestions,
      correct: entity.correct,
      incorrect: entity.incorrect,
      skipped: entity.skipped,
      accuracyPercent: entity.accuracyPercent,
      averageSecondsPerQuestion: entity.averageSecondsPerQuestion,
      totalMinutes: entity.totalMinutes,
      xpEarned: entity.xpEarned,
      weakestTopicId: entity.weakestTopicId,
      weakestTopicName: entity.weakestTopicName,
      weakestTopicAccuracy: entity.weakestTopicAccuracy,
      achievementBadgeId: entity.achievementBadgeId,
    );
  }
}