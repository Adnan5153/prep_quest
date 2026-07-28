import 'package:flutter/foundation.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/question_progress_entity.dart';
import '../../domain/entities/quiz_entity.dart';

/// Pure functions that compute per-question and per-quiz scoring from
/// the session state. Lives in the presentation layer because it is
/// only used by widgets and report builders; the repository also runs
/// its own scoring but the engine keeps a local preview so the UI can
/// show running totals.
class QuizScoreCalculator {
  const QuizScoreCalculator._();

  static int percentFromPoints(int earned, int total) {
    if (total <= 0) return 0;
    return ((earned.clamp(0, total) / total) * 100).round();
  }

  static bool passes(int scorePercent, QuizEntity quiz) {
    return scorePercent >= quiz.passingScorePercent;
  }

  static QuestionScore? scoreQuestion(
    QuestionEntity question,
    QuestionProgressEntity? progress,
  ) {
    if (progress == null || progress.selectedAnswerIds.isEmpty) {
      return null;
    }
    final bool correct = question.isCorrect(progress.selectedAnswerIds);
    return QuestionScore(
      questionId: question.id,
      isCorrect: correct,
      earnedPoints: correct ? question.points : 0,
      totalPoints: question.points,
    );
  }

  static QuizScoreBreakdown breakdown(
    QuizEntity quiz,
    Map<String, QuestionProgressEntity> progress,
  ) {
    int correct = 0;
    int incorrect = 0;
    int skipped = 0;
    int earned = 0;
    int total = 0;
    for (final QuestionEntity q in quiz.questions) {
      total += q.points;
      final QuestionScore? score = scoreQuestion(q, progress[q.id]);
      if (score == null) {
        skipped += 1;
        continue;
      }
      if (score.isCorrect) {
        correct += 1;
        earned += score.earnedPoints;
      } else {
        incorrect += 1;
      }
    }
    return QuizScoreBreakdown(
      correctCount: correct,
      incorrectCount: incorrect,
      skippedCount: skipped,
      totalPoints: total,
      earnedPoints: earned.clamp(0, total),
      scorePercent: percentFromPoints(earned, total),
    );
  }
}

@immutable
class QuestionScore {
  const QuestionScore({
    required this.questionId,
    required this.isCorrect,
    required this.earnedPoints,
    required this.totalPoints,
  });

  final String questionId;
  final bool isCorrect;
  final int earnedPoints;
  final int totalPoints;
}

@immutable
class QuizScoreBreakdown {
  const QuizScoreBreakdown({
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.totalPoints,
    required this.earnedPoints,
    required this.scorePercent,
  });

  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int totalPoints;
  final int earnedPoints;
  final int scorePercent;
}