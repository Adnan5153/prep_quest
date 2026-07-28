import 'package:flutter/foundation.dart';

enum SubjectMastery { novice, learning, confident, mastered }

@immutable
class SubjectStatisticsEntity {
  const SubjectStatisticsEntity({
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
    required this.isPriority,
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
  final bool isPriority;
  final String? achievementBadgeId;

  SubjectMastery get mastery {
    if (totalQuestions == 0) return SubjectMastery.novice;
    if (accuracyPercent >= 90 && totalQuestions >= 80) {
      return SubjectMastery.mastered;
    }
    if (accuracyPercent >= 75 && totalQuestions >= 40) {
      return SubjectMastery.confident;
    }
    if (accuracyPercent >= 50) return SubjectMastery.learning;
    return SubjectMastery.novice;
  }

  bool get hasWeakness =>
      weakestTopicId != null &&
      (weakestTopicAccuracy ?? 100) < 60;

  SubjectStatisticsEntity copyWith({bool? isPriority}) {
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
      isPriority: isPriority ?? this.isPriority,
      achievementBadgeId: achievementBadgeId,
    );
  }
}