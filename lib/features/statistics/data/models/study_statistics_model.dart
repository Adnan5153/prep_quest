import '../../domain/entities/study_statistics_entity.dart';

class StudyStatisticsModel {
  const StudyStatisticsModel({
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

  factory StudyStatisticsModel.fromEntity(StudyStatisticsEntity entity) {
    return StudyStatisticsModel(
      todayMinutes: entity.todayMinutes,
      weeklyMinutes: entity.weeklyMinutes,
      monthlyMinutes: entity.monthlyMinutes,
      averageDailyMinutes: entity.averageDailyMinutes,
      streakDays: entity.streakDays,
      longestStreak: entity.longestStreak,
    );
  }
}