import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/quiz_report_entity.dart';
import 'quiz_providers.dart';

/// Local progress for the quiz engine: bookmarked questions, locally
/// reported questions, and per-quiz completion records.
@immutable
class QuizProgressState {
  const QuizProgressState({
    required this.bookmarkedQuestionIds,
    required this.reportedQuestionIds,
    required this.completedQuizIds,
  });

  final Set<String> bookmarkedQuestionIds;
  final Set<String> reportedQuestionIds;
  final Set<String> completedQuizIds;

  bool isBookmarked(String questionId) =>
      bookmarkedQuestionIds.contains(questionId);
  bool isReported(String questionId) =>
      reportedQuestionIds.contains(questionId);
  bool isCompleted(String quizId) => completedQuizIds.contains(quizId);

  QuizProgressState copyWith({
    Set<String>? bookmarkedQuestionIds,
    Set<String>? reportedQuestionIds,
    Set<String>? completedQuizIds,
  }) {
    return QuizProgressState(
      bookmarkedQuestionIds: bookmarkedQuestionIds ?? this.bookmarkedQuestionIds,
      reportedQuestionIds: reportedQuestionIds ?? this.reportedQuestionIds,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
    );
  }

  static const QuizProgressState empty = QuizProgressState(
    bookmarkedQuestionIds: <String>{},
    reportedQuestionIds: <String>{},
    completedQuizIds: <String>{},
  );
}

class QuizProgressController extends StateNotifier<QuizProgressState> {
  QuizProgressController(this._ref) : super(QuizProgressState.empty);

  final Ref _ref;

  Future<void> toggleBookmark(String questionId) async {
    final result = await _ref.read(toggleQuestionBookmarkProvider)(questionId);
    result.fold(
      onFailure: (_) {
        // Locally mirror the toggle so the UI feels responsive even
        // when the repository is offline.
        final next = Set<String>.of(state.bookmarkedQuestionIds);
        if (next.contains(questionId)) {
          next.remove(questionId);
        } else {
          next.add(questionId);
        }
        state = state.copyWith(bookmarkedQuestionIds: next);
      },
      onSuccess: (added) {
        final next = Set<String>.of(state.bookmarkedQuestionIds);
        if (added) {
          next.add(questionId);
        } else {
          next.remove(questionId);
        }
        state = state.copyWith(bookmarkedQuestionIds: next);
      },
    );
  }

  Future<void> reportQuestion({
    required String questionId,
    required String quizId,
    required QuizReportReason reason,
    required String note,
  }) async {
    final result = await _ref.read(reportQuestionProvider)(
      questionId: questionId,
      quizId: quizId,
      reason: reason,
      note: note,
    );
    result.fold(
      onFailure: (_) {
        state = state.copyWith(
          reportedQuestionIds: <String>{
            ...state.reportedQuestionIds,
            questionId,
          },
        );
      },
      onSuccess: (_) {
        state = state.copyWith(
          reportedQuestionIds: <String>{
            ...state.reportedQuestionIds,
            questionId,
          },
        );
      },
    );
  }

  void markCompleted(String quizId) {
    state = state.copyWith(
      completedQuizIds: <String>{...state.completedQuizIds, quizId},
    );
  }

  void reset() {
    state = QuizProgressState.empty;
  }
}

final quizProgressControllerProvider =
    StateNotifierProvider<QuizProgressController, QuizProgressState>((ref) {
      return QuizProgressController(ref);
    });