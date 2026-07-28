import '../../domain/entities/generated_question.dart';

class GeneratedQuestionOptionModel {
  const GeneratedQuestionOptionModel({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  final String id;
  final String text;
  final bool isCorrect;

  GeneratedQuestionOption toEntity() {
    return GeneratedQuestionOption(
      id: id,
      text: text,
      isCorrect: isCorrect,
    );
  }
}

class GeneratedQuestionModel {
  const GeneratedQuestionModel({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctAnswerIds,
    required this.topic,
    required this.explanation,
    required this.difficultyId,
  });

  final String id;
  final String prompt;
  final List<GeneratedQuestionOptionModel> options;
  final List<String> correctAnswerIds;
  final String topic;
  final String explanation;
  final String difficultyId;

  GeneratedQuestion toEntity() {
    return GeneratedQuestion(
      id: id,
      prompt: prompt,
      options: options
          .map((GeneratedQuestionOptionModel o) => o.toEntity())
          .toList(growable: false),
      correctAnswerIds: List<String>.unmodifiable(correctAnswerIds),
      topic: topic,
      explanation: explanation,
      difficulty: _difficultyFromId(difficultyId),
    );
  }

  static GeneratedQuestionDifficulty _difficultyFromId(String id) {
    for (final GeneratedQuestionDifficulty d in GeneratedQuestionDifficulty.values) {
      if (d.name == id) return d;
    }
    return GeneratedQuestionDifficulty.medium;
  }
}

class GeneratedQuestionSetModel {
  const GeneratedQuestionSetModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    required this.createdAtIso,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String subject;
  final List<GeneratedQuestionModel> questions;
  final String createdAtIso;

  GeneratedQuestionSet toEntity() {
    return GeneratedQuestionSet(
      id: id,
      title: title,
      subtitle: subtitle,
      subject: subject,
      questions: questions
          .map((GeneratedQuestionModel q) => q.toEntity())
          .toList(growable: false),
      createdAt: DateTime.parse(createdAtIso),
    );
  }
}