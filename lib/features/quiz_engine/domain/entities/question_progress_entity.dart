import 'package:flutter/foundation.dart';

/// Snapshot of the user's progress on a single question inside a
/// running quiz session.
@immutable
class QuestionProgressEntity {
  const QuestionProgressEntity({
    required this.questionId,
    required this.selectedAnswerIds,
    required this.status,
    required this.timeSpentSeconds,
    required this.attemptCount,
    required this.hintIdsRevealed,
    required this.isBookmarked,
  });

  final String questionId;
  final List<String> selectedAnswerIds;
  final QuestionProgressStatus status;
  final int timeSpentSeconds;
  final int attemptCount;
  final List<String> hintIdsRevealed;
  final bool isBookmarked;

  bool get hasAnswered => status != QuestionProgressStatus.unanswered;
  bool get isFlagged => status == QuestionProgressStatus.flagged;
  bool get isSkipped => status == QuestionProgressStatus.skipped;
  bool get isAnswered =>
      status == QuestionProgressStatus.answered ||
      status == QuestionProgressStatus.correct ||
      status == QuestionProgressStatus.incorrect;

  QuestionProgressEntity copyWith({
    String? questionId,
    List<String>? selectedAnswerIds,
    QuestionProgressStatus? status,
    int? timeSpentSeconds,
    int? attemptCount,
    List<String>? hintIdsRevealed,
    bool? isBookmarked,
  }) {
    return QuestionProgressEntity(
      questionId: questionId ?? this.questionId,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      status: status ?? this.status,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      attemptCount: attemptCount ?? this.attemptCount,
      hintIdsRevealed: hintIdsRevealed ?? this.hintIdsRevealed,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

enum QuestionProgressStatus {
  unanswered,
  answered,
  flagged,
  skipped,
  correct,
  incorrect,
}
