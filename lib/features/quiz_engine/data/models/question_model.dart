import '../../../../shared/enums/question_type.dart';
import '../../domain/entities/answer_entity.dart';
import '../../domain/entities/hint_entity.dart';
import '../../domain/entities/question_entity.dart';

/// Data-layer model for [QuestionEntity]. Adds a `toEntity` mapper so
/// the domain layer never sees a model.
class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.quizId,
    required this.typeId,
    required this.prompt,
    required this.answers,
    required this.correctAnswerIds,
    required this.difficulty,
    required this.tags,
    required this.topic,
    required this.points,
    this.imageUrl,
    this.hints = const <HintModel>[],
    this.explanation,
    this.mediaCaption,
    this.timeLimitSeconds,
  });

  final String id;
  final String quizId;
  final String typeId;
  final String prompt;
  final List<AnswerModel> answers;
  final List<String> correctAnswerIds;
  final String difficulty;
  final List<String> tags;
  final String topic;
  final int points;
  final String? imageUrl;
  final List<HintModel> hints;
  final String? explanation;
  final String? mediaCaption;
  final int? timeLimitSeconds;

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      quizId: quizId,
      type: _typeFromId(typeId),
      prompt: prompt,
      answers: answers.map((AnswerModel a) => a.toEntity()).toList(growable: false),
      correctAnswerIds: List<String>.unmodifiable(correctAnswerIds),
      difficulty: difficulty,
      tags: List<String>.unmodifiable(tags),
      topic: topic,
      points: points,
      imageUrl: imageUrl,
      hints: hints.map((HintModel h) => h.toEntity()).toList(growable: false),
      explanation: explanation,
      mediaCaption: mediaCaption,
      timeLimitSeconds: timeLimitSeconds,
    );
  }

  bool isCorrect(Iterable<String> selectedAnswerIds) {
    final Set<String> selected = selectedAnswerIds.toSet();
    if (selected.length != correctAnswerIds.length) return false;
    return selected.containsAll(correctAnswerIds);
  }

  static QuestionType _typeFromId(String id) {
    for (final QuestionType t in QuestionType.values) {
      if (t.id == id) return t;
    }
    return QuestionType.singleChoice;
  }
}

class AnswerModel {
  const AnswerModel({
    required this.id,
    required this.text,
    this.imageUrl,
    this.isCorrect = false,
  });

  final String id;
  final String text;
  final String? imageUrl;
  final bool isCorrect;

  AnswerEntity toEntity() {
    return AnswerEntity(
      id: id,
      text: text,
      imageUrl: imageUrl,
      isCorrect: isCorrect,
    );
  }
}

class HintModel {
  const HintModel({
    required this.id,
    required this.text,
    this.tierId = 'free',
    this.costCoins = 0,
  });

  final String id;
  final String text;
  final String tierId;
  final int costCoins;

  HintEntity toEntity() {
    return HintEntity(
      id: id,
      text: text,
      tier: tierId == 'premium' ? QuizHintTier.premium : QuizHintTier.free,
      costCoins: costCoins,
    );
  }
}
