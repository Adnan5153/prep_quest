import '../../domain/entities/review_session_entity.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import 'review_question_model.dart';

class ReviewSessionModel {
  const ReviewSessionModel({
    required this.sessionId,
    required this.quiz,
    required this.questions,
    required this.startedAtIso,
    required this.completedAtIso,
  });

  final String sessionId;
  final QuizModel quiz;
  final List<ReviewQuestionModel> questions;
  final String startedAtIso;
  final String completedAtIso;

  ReviewSessionEntity toEntity() {
    return ReviewSessionEntity(
      sessionId: sessionId,
      quiz: quiz.toEntity(),
      questions: questions
          .map((ReviewQuestionModel q) => q.toEntity())
          .toList(growable: false),
      startedAt: DateTime.parse(startedAtIso),
      completedAt: DateTime.parse(completedAtIso),
    );
  }
}