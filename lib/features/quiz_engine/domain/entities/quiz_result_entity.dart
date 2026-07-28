import 'package:flutter/foundation.dart';

import 'quiz_entity.dart';

/// Domain entity describing the outcome of a quiz session after
/// submission.
@immutable
class QuizResultEntity {
  const QuizResultEntity({
    required this.sessionId,
    required this.quizId,
    required this.scorePercent,
    required this.totalPoints,
    required this.earnedPoints,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.timeSpentSeconds,
    required this.passed,
    required this.rewardXp,
    required this.rewardCoins,
    required this.questionResults,
    required this.difficulty,
    this.completedAt,
  });

  final String sessionId;
  final String quizId;
  final int scorePercent;
  final int totalPoints;
  final int earnedPoints;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int timeSpentSeconds;
  final bool passed;
  final int rewardXp;
  final int rewardCoins;
  final Map<String, bool> questionResults;
  final QuizDifficulty difficulty;
  final DateTime? completedAt;

  int get answeredCount => correctCount + incorrectCount;
  bool get isPerfect => correctCount == questionResults.length;

  @override
  String toString() =>
      'QuizResultEntity(score: $scorePercent%, passed: $passed, '
      'correct: $correctCount/${questionResults.length})';
}
