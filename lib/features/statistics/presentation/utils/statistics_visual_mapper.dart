import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/study_statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';

class StatisticsVisualMapper {
  const StatisticsVisualMapper._();

  static StatisticsVisual toVisual(StatisticsEntity statistics) {
    return StatisticsVisual(
      totalXp: statistics.totalXp,
      todayXp: statistics.todayXp,
      weeklyXp: statistics.weeklyXp,
      monthlyXp: statistics.monthlyXp,
      levelProgress: LevelProgressVisual(
        level: statistics.currentLevel,
        currentXp: statistics.currentXpIntoLevel,
        requiredXp: statistics.nextLevelXp,
        ratio: statistics.levelProgressRatio,
        xpToNext: statistics.xpToNextLevel,
      ),
      xpGrowth: statistics.xpGrowth
          .map((p) => ChartPoint(label: p.label, value: p.xp.toDouble()))
          .toList(),
      accuracy: AccuracyVisual(
        overallPercent: statistics.overallAccuracyPercent,
        correctCount: statistics.totalCorrect,
        incorrectCount: statistics.totalIncorrect,
        skippedCount: statistics.totalSkipped,
        correctRatio: statistics.correctRatio,
        incorrectRatio: statistics.incorrectRatio,
        skippedRatio: statistics.skippedRatio,
      ),
      dailyAccuracy: statistics.dailyAccuracy
          .map((p) =>
              ChartPoint(label: p.label, value: p.accuracyPercent.toDouble()))
          .toList(),
      weeklyAccuracy: statistics.weeklyAccuracy
          .map((p) =>
              ChartPoint(label: p.label, value: p.accuracyPercent.toDouble()))
          .toList(),
      subjects: statistics.subjectBreakdown
          .map((s) => SubjectBreakdownVisual(
                subjectId: s.subjectId,
                subjectName: s.subjectName,
                accuracyPercent: s.accuracyPercent,
                totalQuestions: s.totalQuestions,
                correct: s.correct,
                incorrect: s.incorrect,
                averageSecondsPerQuestion: s.averageSecondsPerQuestion,
                totalMinutes: s.totalMinutes,
                xpEarned: s.xpEarned,
                mastery: s.mastery,
              ))
          .toList(),
      study: StudyVisual(
        todayMinutes: statistics.study.todayMinutes,
        weeklyMinutes: statistics.study.weeklyMinutes,
        monthlyMinutes: statistics.study.monthlyMinutes,
        averageDailyMinutes: statistics.study.averageDailyMinutes,
        streakDays: statistics.study.streakDays,
        longestStreak: statistics.study.longestStreak,
      ),
      weeklyActivity: statistics.weeklyActivity
          .map((p) =>
              ChartPoint(label: p.label, value: p.minutes.toDouble()))
          .toList(),
      monthlyActivity: statistics.monthlyActivity
          .map((p) =>
              ChartPoint(label: p.label, value: p.minutes.toDouble()))
          .toList(),
      heatmap: statistics.studyHeatmap,
      weakSubjects: statistics.weakSubjects.map(SubjectTileVisual.from).toList(),
      strongSubjects:
          statistics.strongSubjects.map(SubjectTileVisual.from).toList(),
      recommendations: statistics.weakSubjects
          .where((s) => s.hasWeakness)
          .map(SubjectTileVisual.from)
          .toList(),
    );
  }
}

class StatisticsVisual {
  const StatisticsVisual({
    required this.totalXp,
    required this.todayXp,
    required this.weeklyXp,
    required this.monthlyXp,
    required this.levelProgress,
    required this.xpGrowth,
    required this.accuracy,
    required this.dailyAccuracy,
    required this.weeklyAccuracy,
    required this.subjects,
    required this.study,
    required this.weeklyActivity,
    required this.monthlyActivity,
    required this.heatmap,
    required this.weakSubjects,
    required this.strongSubjects,
    required this.recommendations,
  });

  final int totalXp;
  final int todayXp;
  final int weeklyXp;
  final int monthlyXp;
  final LevelProgressVisual levelProgress;
  final List<ChartPoint> xpGrowth;
  final AccuracyVisual accuracy;
  final List<ChartPoint> dailyAccuracy;
  final List<ChartPoint> weeklyAccuracy;
  final List<SubjectBreakdownVisual> subjects;
  final StudyVisual study;
  final List<ChartPoint> weeklyActivity;
  final List<ChartPoint> monthlyActivity;
  final List<HeatmapCell> heatmap;
  final List<SubjectTileVisual> weakSubjects;
  final List<SubjectTileVisual> strongSubjects;
  final List<SubjectTileVisual> recommendations;
}

class LevelProgressVisual {
  const LevelProgressVisual({
    required this.level,
    required this.currentXp,
    required this.requiredXp,
    required this.ratio,
    required this.xpToNext,
  });

  final int level;
  final int currentXp;
  final int requiredXp;
  final double ratio;
  final int xpToNext;
}

class AccuracyVisual {
  const AccuracyVisual({
    required this.overallPercent,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.correctRatio,
    required this.incorrectRatio,
    required this.skippedRatio,
  });

  final int overallPercent;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final double correctRatio;
  final double incorrectRatio;
  final double skippedRatio;
}

class ChartPoint {
  const ChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class SubjectBreakdownVisual {
  const SubjectBreakdownVisual({
    required this.subjectId,
    required this.subjectName,
    required this.accuracyPercent,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.averageSecondsPerQuestion,
    required this.totalMinutes,
    required this.xpEarned,
    required this.mastery,
  });

  final String subjectId;
  final String subjectName;
  final int accuracyPercent;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int averageSecondsPerQuestion;
  final int totalMinutes;
  final int xpEarned;
  final SubjectMastery mastery;
}

class SubjectTileVisual {
  const SubjectTileVisual({
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
    required this.weakestTopicName,
    required this.weakestTopicAccuracy,
    required this.isPriority,
    required this.achievementBadgeId,
    required this.mastery,
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
  final String? weakestTopicName;
  final int? weakestTopicAccuracy;
  final bool isPriority;
  final String? achievementBadgeId;
  final SubjectMastery mastery;

  factory SubjectTileVisual.from(SubjectStatisticsEntity entity) {
    return SubjectTileVisual(
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
      weakestTopicName: entity.weakestTopicName,
      weakestTopicAccuracy: entity.weakestTopicAccuracy,
      isPriority: entity.isPriority,
      achievementBadgeId: entity.achievementBadgeId,
      mastery: entity.mastery,
    );
  }
}

class StudyVisual {
  const StudyVisual({
    required this.todayMinutes,
    required this.weeklyMinutes,
    required this.monthlyMinutes,
    required this.averageDailyMinutes,
    required this.streakDays,
    required this.longestStreak,
  });

  final int todayMinutes;
  final int weeklyMinutes;
  final int monthlyMinutes;
  final int averageDailyMinutes;
  final int streakDays;
  final int longestStreak;
}

extension StudyVisualX on StudyVisual {
  StudyStatisticsEntity toEntity() {
    return StudyStatisticsEntity(
      todayMinutes: todayMinutes,
      weeklyMinutes: weeklyMinutes,
      monthlyMinutes: monthlyMinutes,
      averageDailyMinutes: averageDailyMinutes,
      streakDays: streakDays,
      longestStreak: longestStreak,
    );
  }
}