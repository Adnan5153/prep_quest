import '../../domain/entities/quiz_question_entity.dart';

/// Data-layer model for a quiz question served by the Quiz Hub API.
///
/// Questions are stored under a [categoryId] and carry an
/// [answerIndex] (which entry of [options] is correct) and a [mark]
/// (weight per correct answer).
class QuizQuestionModel {
  const QuizQuestionModel({
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

  QuizQuestionEntity toEntity() {
    return QuizQuestionEntity(
      id: id,
      categoryId: categoryId,
      prompt: prompt,
      options: List<String>.unmodifiable(options),
      answerIndex: answerIndex,
      mark: mark,
    );
  }

  factory QuizQuestionModel.fromApiResponse(Map<String, dynamic> response) {
    final Map<String, dynamic>? inner =
        response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : null;
    final Map<String, dynamic> source = inner ?? response;
    return QuizQuestionModel.fromJson(source);
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawOptions =
        json['options'] as List<dynamic>? ?? <dynamic>[];
    return QuizQuestionModel(
      id: '${json['id'] ?? ''}',
      categoryId: '${json['categoryId'] ?? ''}',
      prompt: (json['prompt'] ?? json['question'] ?? '').toString(),
      options: rawOptions
          .whereType<String>()
          .where((String o) => o.isNotEmpty)
          .toList(growable: false),
      answerIndex: (json['answerIndex'] as num?)?.toInt() ?? 0,
      mark: (json['mark'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'prompt': prompt,
      'options': options,
      'answerIndex': answerIndex,
      'mark': mark,
    };
  }
}