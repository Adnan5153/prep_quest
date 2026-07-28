import '../../domain/entities/quiz_entity.dart';
import 'question_model.dart';

class QuizModel {
  const QuizModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.kindId,
    required this.difficultyId,
    required this.questions,
    required this.rewardXp,
    required this.rewardCoins,
    required this.tags,
    required this.availableFromIso,
    required this.availableUntilIso,
    this.description,
    this.timeLimitSeconds,
    this.requiresLevel = 1,
    this.passingScorePercent = 60,
    this.negativeMarkingPercent = 0,
    this.shuffleQuestions = false,
    this.shuffleAnswers = false,
    this.allowSkip = true,
    this.allowReview = true,
    this.allowBookmark = true,
    this.isPremium = false,
    this.nodeId,
  });

  final String id;
  final String title;
  final String subject;
  final String kindId;
  final String difficultyId;
  final List<QuestionModel> questions;
  final int rewardXp;
  final int rewardCoins;
  final List<String> tags;
  final String availableFromIso;
  final String availableUntilIso;
  final String? description;
  final int? timeLimitSeconds;
  final int requiresLevel;
  final int passingScorePercent;
  final int negativeMarkingPercent;
  final bool shuffleQuestions;
  final bool shuffleAnswers;
  final bool allowSkip;
  final bool allowReview;
  final bool allowBookmark;
  final bool isPremium;
  final String? nodeId;

  QuizEntity toEntity() {
    return QuizEntity(
      id: id,
      title: title,
      subject: subject,
      kind: _kindFromId(kindId),
      difficulty: _difficultyFromId(difficultyId),
      questions: questions
          .map((QuestionModel q) => q.toEntity())
          .toList(growable: false),
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      tags: List<String>.unmodifiable(tags),
      availableFrom: DateTime.parse(availableFromIso),
      availableUntil: DateTime.parse(availableUntilIso),
      description: description,
      timeLimitSeconds: timeLimitSeconds,
      requiresLevel: requiresLevel,
      passingScorePercent: passingScorePercent,
      negativeMarkingPercent: negativeMarkingPercent,
      shuffleQuestions: shuffleQuestions,
      shuffleAnswers: shuffleAnswers,
      allowSkip: allowSkip,
      allowReview: allowReview,
      allowBookmark: allowBookmark,
      isPremium: isPremium,
      nodeId: nodeId,
    );
  }

  static QuizKind _kindFromId(String id) {
    for (final QuizKind k in QuizKind.values) {
      if (k.name == id) return k;
    }
    return QuizKind.custom;
  }

  static QuizDifficulty _difficultyFromId(String id) {
    for (final QuizDifficulty d in QuizDifficulty.values) {
      if (d.name == id) return d;
    }
    return QuizDifficulty.medium;
  }
}

