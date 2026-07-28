import '../../domain/entities/review_question_entity.dart';
import '../../../quiz_engine/data/models/question_model.dart';

/// Data-layer model for [ReviewQuestionEntity].
///
/// Combines a quiz-engine [QuestionModel] (which provides `toEntity`
/// for the question itself) with the user's attempt metadata in a
/// single transport-friendly shape.
class ReviewQuestionModel {
  const ReviewQuestionModel({
    required this.question,
    required this.selectedAnswerIds,
    required this.wasCorrect,
    required this.attemptedAtIso,
    required this.quizTitle,
    required this.quizId,
    this.timeSpentSeconds = 0,
    this.isBookmarked = false,
    this.isSkipped = false,
  });

  final QuestionModel question;
  final List<String> selectedAnswerIds;
  final bool wasCorrect;
  final String attemptedAtIso;
  final String quizTitle;
  final String quizId;
  final int timeSpentSeconds;
  final bool isBookmarked;
  final bool isSkipped;

  ReviewQuestionEntity toEntity() {
    return ReviewQuestionEntity(
      question: question.toEntity(),
      selectedAnswerIds: List<String>.unmodifiable(selectedAnswerIds),
      wasCorrect: wasCorrect,
      attemptedAt: DateTime.parse(attemptedAtIso),
      quizTitle: quizTitle,
      quizId: quizId,
      timeSpentSeconds: timeSpentSeconds,
      isBookmarked: isBookmarked,
      isSkipped: isSkipped,
    );
  }
}