import 'package:flutter/foundation.dart';

import '../../../quiz_engine/domain/entities/quiz_entity.dart';
import 'review_question_entity.dart';

/// High-level filter for the Review feature.
enum ReviewFilter { all, correct, incorrect, bookmarked }

/// Immutable summary of a single Review session for one quiz attempt.
@immutable
class ReviewSessionEntity {
  const ReviewSessionEntity({
    required this.sessionId,
    required this.quiz,
    required this.questions,
    required this.startedAt,
    required this.completedAt,
  });

  final String sessionId;
  final QuizEntity quiz;
  final List<ReviewQuestionEntity> questions;
  final DateTime startedAt;
  final DateTime completedAt;

  Iterable<ReviewQuestionEntity> get correctQuestions {
    return questions.where((ReviewQuestionEntity q) => q.wasCorrect);
  }

  Iterable<ReviewQuestionEntity> get incorrectQuestions {
    return questions.where(
      (ReviewQuestionEntity q) => q.hasAnswered && !q.wasCorrect,
    );
  }

  Iterable<ReviewQuestionEntity> get skippedQuestions {
    return questions.where((ReviewQuestionEntity q) => !q.hasAnswered);
  }

  Iterable<ReviewQuestionEntity> get bookmarkedQuestions {
    return questions.where((ReviewQuestionEntity q) => q.isBookmarked);
  }

  int get correctCount => correctQuestions.length;
  int get incorrectCount => incorrectQuestions.length;
  int get skippedCount => skippedQuestions.length;
  int get bookmarkedCount => bookmarkedQuestions.length;
  int get totalCount => questions.length;

  Duration get duration => completedAt.difference(startedAt);
}