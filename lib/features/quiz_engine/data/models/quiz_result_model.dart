import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';

class QuizResultModel {
  const QuizResultModel({
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
    required this.difficultyId,
    this.completedAtIso,
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
  final String difficultyId;
  final String? completedAtIso;

  QuizResultEntity toEntity() {
    return QuizResultEntity(
      sessionId: sessionId,
      quizId: quizId,
      scorePercent: scorePercent,
      totalPoints: totalPoints,
      earnedPoints: earnedPoints,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      skippedCount: skippedCount,
      timeSpentSeconds: timeSpentSeconds,
      passed: passed,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      questionResults: Map<String, bool>.unmodifiable(questionResults),
      difficulty: _difficultyFromId(difficultyId),
      completedAt:
          completedAtIso == null ? null : DateTime.parse(completedAtIso!),
    );
  }

  static QuizDifficulty _difficultyFromId(String id) {
    for (final QuizDifficulty d in QuizDifficulty.values) {
      if (d.name == id) return d;
    }
    return QuizDifficulty.medium;
  }
}
