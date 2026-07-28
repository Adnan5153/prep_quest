import 'package:flutter/foundation.dart';

import 'question_entity.dart';

/// Difficulty tier for a quiz.
enum QuizDifficulty { easy, medium, hard, mixed }

/// Source/category of a quiz (lesson practice, daily challenge, mock
/// test, boss, etc.).
enum QuizKind { lessonPractice, dailyChallenge, mockTest, bossGate, custom }

/// Top-level domain entity describing a static quiz definition.
///
/// A [QuizEntity] is *configuration*: the questions it contains, the
/// timer policy, the reward grants, and any prerequisites. The runtime
/// instance — the user's answers, score, and timing — lives in
/// [QuizSessionEntity].
@immutable
class QuizEntity {
  const QuizEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.kind,
    required this.difficulty,
    required this.questions,
    required this.rewardXp,
    required this.rewardCoins,
    required this.tags,
    required this.availableFrom,
    required this.availableUntil,
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
  final QuizKind kind;
  final QuizDifficulty difficulty;
  final List<QuestionEntity> questions;
  final int rewardXp;
  final int rewardCoins;
  final List<String> tags;
  final DateTime availableFrom;
  final DateTime availableUntil;
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

  bool get isTimed => timeLimitSeconds != null && timeLimitSeconds! > 0;
  bool get isAvailable =>
      DateTime.now().isAfter(availableFrom) &&
      DateTime.now().isBefore(availableUntil);

  int get totalPoints =>
      questions.fold<int>(0, (int sum, QuestionEntity q) => sum + q.points);

  QuestionEntity? questionById(String id) {
    for (final QuestionEntity q in questions) {
      if (q.id == id) return q;
    }
    return null;
  }
}
