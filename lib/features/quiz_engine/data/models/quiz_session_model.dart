import '../../domain/entities/question_progress_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';

/// Data-layer model for [QuizSessionEntity]. Used for both persistence
/// and the in-memory mock.
class QuizSessionModel {
  const QuizSessionModel({
    required this.sessionId,
    required this.quizId,
    required this.startedAtIso,
    required this.questionOrder,
    required this.progress,
    required this.statusId,
    required this.flags,
    required this.totalPausedSeconds,
    this.completedAtIso,
    this.currentIndex = 0,
  });

  final String sessionId;
  final String quizId;
  final String startedAtIso;
  final String? completedAtIso;
  final List<String> questionOrder;
  final Map<String, QuestionProgressModel> progress;
  final String statusId;
  final Set<String> flags;
  final int totalPausedSeconds;
  final int currentIndex;

  QuizSessionEntity toEntity() {
    final Map<String, QuestionProgressEntity> map =
        <String, QuestionProgressEntity>{};
    progress.forEach((String key, QuestionProgressModel value) {
      map[key] = value.toEntity();
    });
    return QuizSessionEntity(
      sessionId: sessionId,
      quizId: quizId,
      startedAt: DateTime.parse(startedAtIso),
      completedAt:
          completedAtIso == null ? null : DateTime.parse(completedAtIso!),
      questionOrder: List<String>.unmodifiable(questionOrder),
      progress: Map<String, QuestionProgressEntity>.unmodifiable(map),
      status: _statusFromId(statusId),
      flags: Set<String>.unmodifiable(flags),
      totalPausedSeconds: totalPausedSeconds,
      currentIndex: currentIndex,
    );
  }

  static QuizSessionStatus _statusFromId(String id) {
    for (final QuizSessionStatus s in QuizSessionStatus.values) {
      if (s.name == id) return s;
    }
    return QuizSessionStatus.initial;
  }
}

class QuestionProgressModel {
  const QuestionProgressModel({
    required this.questionId,
    required this.selectedAnswerIds,
    required this.statusId,
    required this.timeSpentSeconds,
    required this.attemptCount,
    required this.hintIdsRevealed,
    required this.isBookmarked,
  });

  final String questionId;
  final List<String> selectedAnswerIds;
  final String statusId;
  final int timeSpentSeconds;
  final int attemptCount;
  final List<String> hintIdsRevealed;
  final bool isBookmarked;

  QuestionProgressEntity toEntity() {
    return QuestionProgressEntity(
      questionId: questionId,
      selectedAnswerIds: List<String>.unmodifiable(selectedAnswerIds),
      status: _statusFromId(statusId),
      timeSpentSeconds: timeSpentSeconds,
      attemptCount: attemptCount,
      hintIdsRevealed: List<String>.unmodifiable(hintIdsRevealed),
      isBookmarked: isBookmarked,
    );
  }

  static QuestionProgressStatus _statusFromId(String id) {
    for (final QuestionProgressStatus s in QuestionProgressStatus.values) {
      if (s.name == id) return s;
    }
    return QuestionProgressStatus.unanswered;
  }
}
