import 'package:flutter/foundation.dart';

/// A single AI-generated practice question.
@immutable
class GeneratedQuestion {
  const GeneratedQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctAnswerIds,
    required this.topic,
    required this.explanation,
    required this.difficulty,
  });

  final String id;
  final String prompt;
  final List<GeneratedQuestionOption> options;
  final List<String> correctAnswerIds;
  final String topic;
  final String explanation;
  final GeneratedQuestionDifficulty difficulty;

  bool get isMultiSelect => correctAnswerIds.length > 1;

  GeneratedQuestion copyWith({
    String? id,
    String? prompt,
    List<GeneratedQuestionOption>? options,
    List<String>? correctAnswerIds,
    String? topic,
    String? explanation,
    GeneratedQuestionDifficulty? difficulty,
  }) {
    return GeneratedQuestion(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options,
      correctAnswerIds: correctAnswerIds ?? this.correctAnswerIds,
      topic: topic ?? this.topic,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

enum GeneratedQuestionDifficulty { easy, medium, hard }

@immutable
class GeneratedQuestionOption {
  const GeneratedQuestionOption({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  final String id;
  final String text;
  final bool isCorrect;
}

/// A Q&A batch produced by the AI tutor (typically 5–10 questions).
@immutable
class GeneratedQuestionSet {
  const GeneratedQuestionSet({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    required this.createdAt,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String subject;
  final List<GeneratedQuestion> questions;
  final DateTime createdAt;

  int get questionCount => questions.length;
}