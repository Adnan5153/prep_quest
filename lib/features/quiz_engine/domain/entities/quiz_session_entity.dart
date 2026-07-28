import 'package:flutter/foundation.dart';

import 'question_progress_entity.dart';

/// Runtime state of a quiz session — the user's interactions with a
/// particular [QuizEntity]. Mutated as the user moves through
/// questions; finalised into a [QuizResultEntity] on submit.
@immutable
class QuizSessionEntity {
  const QuizSessionEntity({
    required this.sessionId,
    required this.quizId,
    required this.startedAt,
    required this.questionOrder,
    required this.progress,
    required this.status,
    required this.flags,
    required this.totalPausedSeconds,
    this.completedAt,
    this.currentIndex = 0,
  });

  final String sessionId;
  final String quizId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> questionOrder;
  final Map<String, QuestionProgressEntity> progress;
  final QuizSessionStatus status;
  final Set<String> flags;
  final int totalPausedSeconds;
  final int currentIndex;

  bool get isComplete =>
      status == QuizSessionStatus.completed ||
      status == QuizSessionStatus.abandoned ||
      status == QuizSessionStatus.expired ||
      status == QuizSessionStatus.failed;

  int get answeredCount =>
      progress.values.where((QuestionProgressEntity p) => p.hasAnswered).length;

  int get flaggedCount =>
      progress.values.where((QuestionProgressEntity p) => p.isFlagged).length;

  String get currentQuestionId =>
      questionOrder.isEmpty ? '' : questionOrder[currentIndex];

  bool canMoveNext() => currentIndex < questionOrder.length - 1;
  bool canMovePrevious() => currentIndex > 0;
}

enum QuizSessionStatus {
  initial,
  inProgress,
  paused,
  completed,
  abandoned,
  expired,
  failed,
}
