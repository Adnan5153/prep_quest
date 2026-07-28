import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';
import 'study_statistics_model.dart';
import 'subject_statistics_model.dart';

class StatisticsModel {
  const StatisticsModel({
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
  final StudyStatisticsModel study;
  final List<SubjectStatisticsModel> subjectBreakdown;
  final List<XpGrowthPoint> xpGrowth;
  final List<AccuracyPoint> dailyAccuracy;
  final List<AccuracyPoint> weeklyAccuracy;
  final List<HeatmapCell> studyHeatmap;
  final List<ActivityPoint> weeklyActivity;
  final List<ActivityPoint> monthlyActivity;

  StatisticsEntity toEntity({
    required List<SubjectStatisticsEntity> weakSubjects,
    required List<SubjectStatisticsEntity> strongSubjects,
  }) {
    return StatisticsEntity(
      totalXp: totalXp,
      todayXp: todayXp,
      weeklyXp: weeklyXp,
      monthlyXp: monthlyXp,
      currentLevel: currentLevel,
      currentXpIntoLevel: currentXpIntoLevel,
      nextLevelXp: nextLevelXp,
      overallAccuracyPercent: overallAccuracyPercent,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      totalIncorrect: totalIncorrect,
      totalSkipped: totalSkipped,
      streakDays: streakDays,
      study: study.toEntity(),
      subjectBreakdown:
          subjectBreakdown.map((model) => model.toEntity()).toList(),
      xpGrowth: xpGrowth,
      dailyAccuracy: dailyAccuracy,
      weeklyAccuracy: weeklyAccuracy,
      studyHeatmap: studyHeatmap,
      weeklyActivity: weeklyActivity,
      monthlyActivity: monthlyActivity,
      weakSubjects: weakSubjects,
      strongSubjects: strongSubjects,
    );
  }
}