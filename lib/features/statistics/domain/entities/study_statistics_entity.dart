import 'package:flutter/foundation.dart';

@immutable
class StudyStatisticsEntity {
  const StudyStatisticsEntity({
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

  int get totalMinutes => weeklyMinutes;

  bool get hasActivityToday => todayMinutes > 0;

  static const StudyStatisticsEntity empty = StudyStatisticsEntity(
    todayMinutes: 0,
    weeklyMinutes: 0,
    monthlyMinutes: 0,
    averageDailyMinutes: 0,
    streakDays: 0,
    longestStreak: 0,
  );
}