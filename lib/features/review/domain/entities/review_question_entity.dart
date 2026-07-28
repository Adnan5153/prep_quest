import 'package:flutter/foundation.dart';

import '../../../quiz_engine/domain/entities/answer_entity.dart';
import '../../../quiz_engine/domain/entities/question_entity.dart' as engine;

/// Aggregate review entry for a previously attempted question.
///
/// Combines the originating [engine.QuestionEntity] with the user's
/// attempt (selected answer ids, correctness, time spent) and the
/// timestamp at which the attempt was recorded. Used by the Review
/// feature to display answered questions across sessions.
@immutable
class ReviewQuestionEntity {
  const ReviewQuestionEntity({
    required this.question,
    required this.selectedAnswerIds,
    required this.wasCorrect,
    required this.attemptedAt,
    required this.quizTitle,
    required this.quizId,
    this.timeSpentSeconds = 0,
    this.isBookmarked = false,
    this.isSkipped = false,
  });

  final engine.QuestionEntity question;
  final List<String> selectedAnswerIds;
  final bool wasCorrect;
  final DateTime attemptedAt;
  final String quizTitle;
  final String quizId;
  final int timeSpentSeconds;
  final bool isBookmarked;
  final bool isSkipped;

  bool get hasAnswered => selectedAnswerIds.isNotEmpty;

  Set<String> get selectedSet => selectedAnswerIds.toSet();

  Iterable<AnswerEntity> get correctAnswers {
    return question.answers
        .where((AnswerEntity a) => a.isCorrect);
  }

  Iterable<AnswerEntity> get incorrectSelections {
    final Set<String> selected = selectedSet;
    return question.answers.where(
      (AnswerEntity a) => selected.contains(a.id) && !a.isCorrect,
    );
  }

  ReviewQuestionEntity copyWith({
    engine.QuestionEntity? question,
    List<String>? selectedAnswerIds,
    bool? wasCorrect,
    DateTime? attemptedAt,
    String? quizTitle,
    String? quizId,
    int? timeSpentSeconds,
    bool? isBookmarked,
    bool? isSkipped,
  }) {
    return ReviewQuestionEntity(
      question: question ?? this.question,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      wasCorrect: wasCorrect ?? this.wasCorrect,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      quizTitle: quizTitle ?? this.quizTitle,
      quizId: quizId ?? this.quizId,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }
}