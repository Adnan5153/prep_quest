/// Domain entity for a quiz question served by the Quiz Hub API.
class QuizQuestionEntity {
  const QuizQuestionEntity({
    required this.id,
    required this.categoryId,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.mark,
  });

  final String id;
  final String categoryId;
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final int mark;

  /// Whether the supplied option index is the correct answer.
  bool isCorrect(int index) => index == answerIndex;
}