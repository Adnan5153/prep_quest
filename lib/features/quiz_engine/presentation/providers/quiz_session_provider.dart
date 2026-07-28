import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/question_progress_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';
import '../../domain/usecases/submit_quiz_session.dart';
import 'quiz_providers.dart';

/// Mutable in-memory editor for a single quiz session.
///
/// Lives outside the [quizSessionControllerProvider] family so the
/// session can be referenced by id from any screen (quiz, review,
/// result, pause) without each rebuilding its own state.
class QuizSessionController extends StateNotifier<QuizSessionEntity> {
  QuizSessionController(super.initial);

  void selectAnswer(String questionId, String answerId) {
    final QuestionEntity? question = _findQuestion(questionId);
    if (question == null) return;
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    final List<String> next = List<String>.of(existing.selectedAnswerIds);
    if (question.allowsMultipleAnswers) {
      if (next.contains(answerId)) {
        next.remove(answerId);
      } else {
        next.add(answerId);
      }
    } else {
      next
        ..clear()
        ..add(answerId);
    }
    final QuestionProgressStatus status = next.isEmpty
        ? QuestionProgressStatus.unanswered
        : (question.isCorrect(next)
              ? QuestionProgressStatus.answered
              : QuestionProgressStatus.answered);
    _updateProgress(
      existing.copyWith(
        selectedAnswerIds: next,
        status: status,
        attemptCount: existing.attemptCount + 1,
      ),
    );
  }

  void clearAnswer(String questionId) {
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    _updateProgress(
      existing.copyWith(
        selectedAnswerIds: const <String>[],
        status: QuestionProgressStatus.unanswered,
      ),
    );
  }

  void flagQuestion(String questionId) {
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    final Set<String> flags = Set<String>.of(state.flags);
    if (flags.contains(questionId)) {
      flags.remove(questionId);
      _updateProgress(
        existing.copyWith(status: QuestionProgressStatus.unanswered),
      );
    } else {
      flags.add(questionId);
      _updateProgress(
        existing.copyWith(status: QuestionProgressStatus.flagged),
      );
    }
    state = state.copyWith(flags: flags);
  }

  void skipQuestion(String questionId) {
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    _updateProgress(
      existing.copyWith(status: QuestionProgressStatus.skipped),
    );
  }

  void revealHint(String questionId, String hintId) {
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    if (existing.hintIdsRevealed.contains(hintId)) return;
    final List<String> revealed = List<String>.of(existing.hintIdsRevealed)
      ..add(hintId);
    _updateProgress(existing.copyWith(hintIdsRevealed: revealed));
  }

  void setBookmarked(String questionId, bool value) {
    final QuestionProgressEntity existing = _ensureProgress(questionId);
    _updateProgress(existing.copyWith(isBookmarked: value));
  }

  void goToQuestion(int index) {
    if (index < 0 || index >= state.questionOrder.length) return;
    state = state.copyWith(currentIndex: index);
  }

  void next() {
    if (state.canMoveNext()) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previous() {
    if (state.canMovePrevious()) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void pause() {
    if (state.isComplete) return;
    state = state.copyWith(status: QuizSessionStatus.paused);
  }

  void resume() {
    if (state.isComplete) return;
    state = state.copyWith(status: QuizSessionStatus.inProgress);
  }

  void abandon() {
    state = state.copyWith(
      status: QuizSessionStatus.abandoned,
      completedAt: DateTime.now(),
    );
  }

  void expire() {
    state = state.copyWith(
      status: QuizSessionStatus.expired,
      completedAt: DateTime.now(),
    );
  }

  void tickTime(int questionId, int seconds) {
    // kept for future per-question timing
    final QuestionProgressEntity existing = _ensureProgress(
      _questionIdByIndex(questionId),
    );
    _updateProgress(
      existing.copyWith(timeSpentSeconds: existing.timeSpentSeconds + seconds),
    );
  }

  String _questionIdByIndex(int index) {
    if (index < 0 || index >= state.questionOrder.length) return '';
    return state.questionOrder[index];
  }

  QuestionEntity? _findQuestion(String questionId) {
    final QuizEntity? quiz = refQuiz;
    if (quiz == null) return null;
    return quiz.questionById(questionId);
  }

  /// Accessor for the originating quiz definition. Wired by the
  /// provider layer so the session controller doesn't have to hold
  /// the quiz reference itself.
  QuizEntity? refQuiz;

  QuestionProgressEntity _ensureProgress(String questionId) {
    return state.progress[questionId] ??
        QuestionProgressEntity(
          questionId: questionId,
          selectedAnswerIds: const <String>[],
          status: QuestionProgressStatus.unanswered,
          timeSpentSeconds: 0,
          attemptCount: 0,
          hintIdsRevealed: const <String>[],
          isBookmarked: false,
        );
  }

  void _updateProgress(QuestionProgressEntity updated) {
    final Map<String, QuestionProgressEntity> map =
        Map<String, QuestionProgressEntity>.of(state.progress);
    map[updated.questionId] = updated;
    state = state.copyWith(progress: map);
  }
}

extension QuizSessionCopy on QuizSessionEntity {
  QuizSessionEntity copyWith({
    String? sessionId,
    String? quizId,
    DateTime? startedAt,
    DateTime? completedAt,
    List<String>? questionOrder,
    Map<String, QuestionProgressEntity>? progress,
    QuizSessionStatus? status,
    Set<String>? flags,
    int? totalPausedSeconds,
    int? currentIndex,
  }) {
    return QuizSessionEntity(
      sessionId: sessionId ?? this.sessionId,
      quizId: quizId ?? this.quizId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      questionOrder: questionOrder ?? this.questionOrder,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      flags: flags ?? this.flags,
      totalPausedSeconds: totalPausedSeconds ?? this.totalPausedSeconds,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

/// Initial session for a given quiz. The session id is generated using
/// the current timestamp so each invocation is unique.
QuizSessionEntity buildInitialSession(QuizEntity quiz) {
  final List<String> order = List<String>.generate(
    quiz.questions.length,
    (int i) => quiz.questions[i].id,
  );
  return QuizSessionEntity(
    sessionId: 'session-${DateTime.now().microsecondsSinceEpoch}',
    quizId: quiz.id,
    startedAt: DateTime.now(),
    questionOrder: List<String>.unmodifiable(order),
    progress: const <String, QuestionProgressEntity>{},
    status: QuizSessionStatus.inProgress,
    flags: const <String>{},
    totalPausedSeconds: 0,
  );
}

/// Family provider keyed by the quiz id. The session is created
/// lazily the first time the provider is read for that quiz.
final quizSessionControllerProvider = StateNotifierProvider.family<
  QuizSessionController,
  QuizSessionEntity,
  String
>((ref, quizId) {
  final QuizDetailState detail = ref.watch(quizDetailControllerProvider(quizId));
  final QuizEntity? quiz = detail.quiz;
  final QuizSessionController controller = QuizSessionController(
    quiz == null ? _emptySession(quizId) : buildInitialSession(quiz),
  );
  controller.refQuiz = quiz;
  return controller;
});

QuizSessionEntity _emptySession(String quizId) {
  return QuizSessionEntity(
    sessionId: 'session-${DateTime.now().microsecondsSinceEpoch}',
    quizId: quizId,
    startedAt: DateTime.now(),
    questionOrder: const <String>[],
    progress: const <String, QuestionProgressEntity>{},
    status: QuizSessionStatus.initial,
    flags: const <String>{},
    totalPausedSeconds: 0,
  );
}

@immutable
class QuizResultState {
  const QuizResultState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  final QuizResultLoadStatus status;
  final QuizResultEntity? result;
  final String? errorMessage;

  QuizResultState copyWith({
    QuizResultLoadStatus? status,
    QuizResultEntity? result,
    String? errorMessage,
  }) {
    return QuizResultState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  static const QuizResultState initial = QuizResultState(
    status: QuizResultLoadStatus.initial,
  );
}

enum QuizResultLoadStatus { initial, loading, ready, error }

class QuizResultController extends StateNotifier<QuizResultState> {
  QuizResultController(this._useCase) : super(QuizResultState.initial);

  final SubmitQuizSession _useCase;

  Future<void> submit(QuizSessionEntity session) async {
    if (state.status == QuizResultLoadStatus.loading) return;
    state = state.copyWith(status: QuizResultLoadStatus.loading);
    final Result<QuizResultEntity> result = await _useCase(session);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: QuizResultLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (result) {
        state = QuizResultState(
          status: QuizResultLoadStatus.ready,
          result: result,
        );
      },
    );
  }
}

final quizResultControllerProvider =
    StateNotifierProvider<QuizResultController, QuizResultState>((ref) {
      return QuizResultController(ref.watch(submitQuizSessionProvider));
    });
