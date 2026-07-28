import '../../domain/entities/question_entity.dart';
import '../../domain/entities/question_progress_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';

extension QuizSessionUtils on QuizSessionEntity {
  int get answeredCount =>
      progress.values.where((QuestionProgressEntity p) => p.hasAnswered).length;

  int get flaggedCount =>
      progress.values.where((QuestionProgressEntity p) => p.isFlagged).length;

  QuestionEntity? currentQuestion(QuizEntity quiz) {
    if (questionOrder.isEmpty) return null;
    final String id = questionOrder[currentIndex];
    return quiz.questionById(id);
  }

  QuestionProgressEntity? progressFor(String questionId) {
    return progress[questionId];
  }

  /// Returns the index of the next unanswered question, or null if
  /// all questions have been answered.
  int? nextUnansweredIndex(QuizEntity quiz) {
    for (int i = 0; i < questionOrder.length; i++) {
      final String id = questionOrder[i];
      final QuestionProgressEntity? p = progress[id];
      if (p == null || !p.hasAnswered) return i;
    }
    return null;
  }
}