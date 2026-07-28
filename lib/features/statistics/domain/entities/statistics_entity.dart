import 'package:flutter/foundation.dart';

import 'study_statistics_entity.dart';
import 'subject_statistics_entity.dart';

@immutable
class StatisticsEntity {
  const StatisticsEntity({
    required this.totalXp,
    required this.todayXp,
    required this.weeklyXp,
    required this.monthlyXp,
    required this.currentLevel,
    required this.currentXpIntoLevel,
    required this.nextLevelXp,
    required this.overallAccuracyPercent,
    required this.totalQuestions,
    required this.totalCorrect,
    required this.totalIncorrect,
    required this.totalSkipped,
    required this.streakDays,
    required this.study,
    required this.subjectBreakdown,
    required this.xpGrowth,
    required this.dailyAccuracy,
    required this.weeklyAccuracy,
    required this.studyHeatmap,
    required this.weeklyActivity,
    required this.monthlyActivity,
    required this.weakSubjects,
    required this.strongSubjects,
  });

  final int totalXp;
  final int todayXp;
  final int weeklyXp;
  final int monthlyXp;
  final int currentLevel;
  final int currentXpIntoLevel;
  final int nextLevelXp;
  final int overallAccuracyPercent;
  final int totalQuestions;
  final int totalCorrect;
  final int totalIncorrect;
  final int totalSkipped;
  final int streakDays;
  final StudyStatisticsEntity study;
  final List<SubjectStatisticsEntity> subjectBreakdown;
  final List<XpGrowthPoint> xpGrowth;
  final List<AccuracyPoint> dailyAccuracy;
  final List<AccuracyPoint> weeklyAccuracy;
  final List<HeatmapCell> studyHeatmap;
  final List<ActivityPoint> weeklyActivity;
  final List<ActivityPoint> monthlyActivity;
  final List<SubjectStatisticsEntity> weakSubjects;
  final List<SubjectStatisticsEntity> strongSubjects;

  double get levelProgressRatio {
    if (nextLevelXp <= 0) return 1.0;
    return (currentXpIntoLevel / nextLevelXp).clamp(0.0, 1.0);
  }

  int get xpToNextLevel =>
      (nextLevelXp - currentXpIntoLevel).clamp(0, nextLevelXp);

  double get correctRatio =>
      totalQuestions == 0 ? 0 : totalCorrect / totalQuestions;

  double get incorrectRatio =>
      totalQuestions == 0 ? 0 : totalIncorrect / totalQuestions;

  double get skippedRatio =>
      totalQuestions == 0 ? 0 : totalSkipped / totalQuestions;

  bool get isEmpty =>
      totalQuestions == 0 && totalXp == 0 && study.totalMinutes == 0;
}

@immutable
class XpGrowthPoint {
  const XpGrowthPoint({required this.label, required this.xp});

  final String label;
  final int xp;
}

@immutable
class AccuracyPoint {
  const AccuracyPoint({required this.label, required this.accuracyPercent});

  final String label;
  final int accuracyPercent;
}

@immutable
class ActivityPoint {
  const ActivityPoint({required this.label, required this.minutes});

  final String label;
  final int minutes;
}

@immutable
class HeatmapCell {
  const HeatmapCell({
    required this.date,
    required this.intensity,
    required this.minutes,
  });

  final DateTime date;
  final double intensity;
  final int minutes;
}