import '../entities/statistics_entity.dart';
import '../entities/study_statistics_entity.dart';
import '../entities/subject_statistics_entity.dart';
import '../entities/user_statistics_entity.dart';

/// Pure aggregator that rebuilds the legacy
/// [StatisticsEntity] / [StudyStatisticsEntity] /
/// [SubjectStatisticsEntity] shapes from the new
/// [UserStatisticsEntity] + [CategoryStatisticsEntity] rows.
///
/// Lives here so the phase-43 realtime Firestore writer can
/// describe its data with the new entities while every existing
/// Phase 28 widget / use case keeps consuming the legacy shapes
/// unchanged.
class StatisticsAggregator {
  const StatisticsAggregator();

  static const double _weakThreshold = 60.0;
  static const double _strongThreshold = 75.0;

  /// Builds the canonical `StatisticsEntity` from the latest
  /// realtime snapshot.
  StatisticsEntity toStatisticsEntity({
    required UserStatisticsEntity user,
    required List<CategoryStatisticsEntity> categories,
  }) {
    final List<SubjectStatisticsEntity> breakdown = toSubjectBreakdown(categories);
    final List<SubjectStatisticsEntity> weak = toWeakSubjects(categories);
    final List<SubjectStatisticsEntity> strong = toStrongSubjects(categories);
    final StudyStatisticsEntity study = toStudyStatisticsEntity(user);

    final int totalQuestions = user.totalAnswered;
    final int totalCorrect = user.correctAnswers;
    final int totalIncorrect = user.wrongAnswers;

    return StatisticsEntity(
      totalXp: user.totalXp,
      todayXp: 0,
      weeklyXp: user.totalXp,
      monthlyXp: user.totalXp,
      currentLevel: 1,
      currentXpIntoLevel: 0,
      nextLevelXp: 100,
      overallAccuracyPercent: user.accuracyPercent,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      totalIncorrect: totalIncorrect,
      totalSkipped: 0,
      streakDays: 0,
      study: study,
      subjectBreakdown: breakdown,
      xpGrowth: const <XpGrowthPoint>[],
      dailyAccuracy: const <AccuracyPoint>[],
      weeklyAccuracy: const <AccuracyPoint>[],
      studyHeatmap: const <HeatmapCell>[],
      weeklyActivity: const <ActivityPoint>[],
      monthlyActivity: const <ActivityPoint>[],
      weakSubjects: weak,
      strongSubjects: strong,
    );
  }

  StudyStatisticsEntity toStudyStatisticsEntity(UserStatisticsEntity user) {
    final int minutes = user.totalStudyMinutes;
    return StudyStatisticsEntity(
      todayMinutes: minutes,
      weeklyMinutes: minutes,
      monthlyMinutes: minutes,
      averageDailyMinutes: minutes,
      streakDays: 0,
      longestStreak: 0,
    );
  }

  List<SubjectStatisticsEntity> toSubjectBreakdown(
    List<CategoryStatisticsEntity> categories,
  ) {
    return categories
        .map(
          (CategoryStatisticsEntity c) => SubjectStatisticsEntity(
            subjectId: c.categoryId,
            subjectName: c.subjectName,
            totalQuestions: c.totalQuestions,
            correct: c.correct,
            incorrect: c.wrong,
            skipped: c.skipped,
            accuracyPercent: c.accuracyPercent,
            averageSecondsPerQuestion: c.averageSecondsPerQuestion.round(),
            totalMinutes: c.totalMinutes,
            xpEarned: c.xpEarned,
            weakestTopicId: null,
            weakestTopicName: null,
            weakestTopicAccuracy: null,
            isPriority: c.isPriority,
            achievementBadgeId: null,
          ),
        )
        .toList(growable: false);
  }

  List<SubjectStatisticsEntity> toWeakSubjects(
    List<CategoryStatisticsEntity> categories,
  ) {
    final List<SubjectStatisticsEntity> all = toSubjectBreakdown(categories);
    return all
        .where((SubjectStatisticsEntity s) => s.accuracyPercent < _weakThreshold)
        .toList(growable: false);
  }

  List<SubjectStatisticsEntity> toStrongSubjects(
    List<CategoryStatisticsEntity> categories,
  ) {
    final List<SubjectStatisticsEntity> all = toSubjectBreakdown(categories);
    return all
        .where((SubjectStatisticsEntity s) => s.accuracyPercent >= _strongThreshold)
        .toList(growable: false);
  }
}
