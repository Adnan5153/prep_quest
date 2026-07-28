import 'package:flutter/foundation.dart';

import '../../../../shared/enums/question_type.dart' as shared;
import 'answer_entity.dart';
import 'hint_entity.dart';

/// Top-level domain entity for a quiz question.
///
/// Pure Flutter-independent data; the presentation layer maps this
/// onto widgets. Lives below the Quiz session, which is responsible
/// for tracking user answers against instances of this entity.
@immutable
class QuestionEntity {
  const QuestionEntity({
    required this.id,
    required this.quizId,
    required this.type,
    required this.prompt,
    required this.answers,
    required this.correctAnswerIds,
    required this.difficulty,
    required this.tags,
    required this.topic,
    required this.points,
    this.imageUrl,
    this.hints = const <HintEntity>[],
    this.explanation,
    this.mediaCaption,
    this.timeLimitSeconds,
  });

  final String id;
  final String quizId;
  final shared.QuestionType type;
  final String prompt;
  final List<AnswerEntity> answers;
  final List<String> correctAnswerIds;
  final String difficulty;
  final List<String> tags;
  final String topic;
  final int points;
  final String? imageUrl;
  final List<HintEntity> hints;
  final String? explanation;
  final String? mediaCaption;
  final int? timeLimitSeconds;

  bool get allowsMultipleAnswers => type == shared.QuestionType.multiSelect;
  bool get isTimed => timeLimitSeconds != null && timeLimitSeconds! > 0;

  /// Whether the supplied answer ids constitute a correct selection.
  ///
  /// Order-independent comparison: the user's selection is correct
  /// iff it contains exactly the same ids as [correctAnswerIds].
  bool isCorrect(Iterable<String> selectedIds) {
    final Set<String> expected = correctAnswerIds.toSet();
    final Set<String> actual = selectedIds.toSet();
    if (expected.length != actual.length) return false;
    return expected.containsAll(actual);
  }

  /// Partial credit for multi-select questions.
  ///
  /// Returns the number of correctly selected ids minus the number of
  /// incorrect selections. The result is clamped to `[0, correctCount]`
  /// so partial credit is never negative.
  int partialCredit(Iterable<String> selectedIds) {
    if (type != shared.QuestionType.multiSelect) {
      return isCorrect(selectedIds) ? 1 : 0;
    }
    final Set<String> expected = correctAnswerIds.toSet();
    final Set<String> actual = selectedIds.toSet();
    int correct = 0;
    int wrong = 0;
    for (final String id in actual) {
      if (expected.contains(id)) {
        correct += 1;
      } else {
        wrong += 1;
      }
    }
    final int credit = correct - wrong;
    if (credit < 0) return 0;
    return credit.clamp(0, expected.length);
  }
}
