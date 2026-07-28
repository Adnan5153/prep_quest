import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';

/// Type-safe payload for a reward trigger.
///
/// Each variant carries exactly the data the reward engine needs to
/// compute a grant; widgets never pass raw maps.
@immutable
sealed class RewardTriggerData {
  const RewardTriggerData();
}

@immutable
class QuizCompletedData extends RewardTriggerData {
  const QuizCompletedData({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.elapsedSeconds,
    required this.difficultyId,
    this.subjectId,
    this.isPerfect = false,
    this.streakDays = 0,
  });

  final int correctAnswers;
  final int totalQuestions;
  final int elapsedSeconds;
  final String difficultyId;
  final String? subjectId;
  final bool isPerfect;
  final int streakDays;
}

@immutable
class LessonCompletedData extends RewardTriggerData {
  const LessonCompletedData({
    required this.lessonId,
    this.chapterId,
    this.completionRatio = 1.0,
  });

  final String lessonId;
  final String? chapterId;
  final double completionRatio;
}

@immutable
class MissionCompletedData extends RewardTriggerData {
  const MissionCompletedData({
    required this.missionId,
    required this.objectivesCompleted,
    required this.totalObjectives,
  });

  final String missionId;
  final int objectivesCompleted;
  final int totalObjectives;
}

@immutable
class LevelCompletedData extends RewardTriggerData {
  const LevelCompletedData({
    required this.levelId,
    required this.isFirstClear,
    this.scoreRatio,
  });

  final String levelId;
  final bool isFirstClear;
  final double? scoreRatio;
}

@immutable
class DailyLoginData extends RewardTriggerData {
  const DailyLoginData({required this.day, required this.streakDays});

  final int day;
  final int streakDays;
}

@immutable
class BadgeEarnedData extends RewardTriggerData {
  const BadgeEarnedData({required this.badgeId});

  final String badgeId;
}

@immutable
class ChestOpenedData extends RewardTriggerData {
  const ChestOpenedData({required this.chestId, this.source});

  final String chestId;
  final RewardTrigger? source;
}