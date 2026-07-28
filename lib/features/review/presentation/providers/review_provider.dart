import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/presentation/providers/quiz_providers.dart';
import '../../data/datasources/review_local_datasource.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review_question_entity.dart';
import '../../domain/entities/review_session_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/get_ai_explanation.dart';
import '../../domain/usecases/get_bookmarked_questions.dart';
import '../../domain/usecases/get_recent_questions.dart';
import '../../domain/usecases/get_review_questions.dart';
import '../../domain/usecases/toggle_bookmark.dart';

// ---------------------------------------------------------------------------
// Data sources & repository providers
// ---------------------------------------------------------------------------

/// Remote data source for the Review feature. Default is the in-memory
/// mock that composes seeded sessions from the Quiz Engine mock.
final Provider<ReviewRemoteDataSource> reviewRemoteDataSourceProvider =
    Provider<ReviewRemoteDataSource>((Ref ref) {
  return ReviewLocalDataSource(
    quizSource: ref.watch(quizRemoteDataSourceProvider),
  );
});

/// Single repository for the Review feature. Reuses the Quiz Engine's
/// mock data source for shared bookmark state.
final Provider<ReviewRepository> reviewRepositoryProvider =
    Provider<ReviewRepository>((Ref ref) {
  return ReviewRepositoryImpl(
    remote: ref.watch(reviewRemoteDataSourceProvider),
    quizSource: ref.watch(quizRemoteDataSourceProvider),
  );
});

// ---------------------------------------------------------------------------
// Use case providers
// ---------------------------------------------------------------------------

final Provider<GetAllReviewSessions> getAllReviewSessionsProvider =
    Provider<GetAllReviewSessions>((Ref ref) {
  return GetAllReviewSessions(ref.watch(reviewRepositoryProvider));
});

final Provider<GetReviewSessionById> getReviewSessionByIdProvider =
    Provider<GetReviewSessionById>((Ref ref) {
  return GetReviewSessionById(ref.watch(reviewRepositoryProvider));
});

final Provider<GetQuestionsForFilter> getQuestionsForFilterProvider =
    Provider<GetQuestionsForFilter>((Ref ref) {
  return GetQuestionsForFilter(ref.watch(reviewRepositoryProvider));
});

final Provider<GetBookmarkedQuestions> getBookmarkedQuestionsProvider =
    Provider<GetBookmarkedQuestions>((Ref ref) {
  return GetBookmarkedQuestions(ref.watch(reviewRepositoryProvider));
});

final Provider<GetRecentQuestions> getRecentQuestionsProvider =
    Provider<GetRecentQuestions>((Ref ref) {
  return GetRecentQuestions(ref.watch(reviewRepositoryProvider));
});

final Provider<GetAiExplanation> getAiExplanationProvider =
    Provider<GetAiExplanation>((Ref ref) {
  return GetAiExplanation(ref.watch(reviewRepositoryProvider));
});

final Provider<ToggleBookmark> toggleBookmarkProvider =
    Provider<ToggleBookmark>((Ref ref) {
  return ToggleBookmark(ref.watch(reviewRepositoryProvider));
});

/// Family provider that fetches a single review session by id. Consumed
/// by the detail screen when the user lands via a deep link before the
/// list has been loaded.
final StateNotifierProviderFamily<ReviewDetailController, ReviewDetailState,
        String>
    reviewDetailControllerProvider =
    StateNotifierProvider.family<ReviewDetailController, ReviewDetailState,
        String>((Ref ref, String sessionId) {
  return ReviewDetailController(
    ref.watch(getReviewSessionByIdProvider),
  )..load(sessionId);
});

@immutable
class ReviewDetailState {
  const ReviewDetailState({
    required this.sessionId,
    required this.status,
    this.session,
    this.errorMessage,
  });

  final String sessionId;
  final ReviewLoadStatus status;
  final ReviewSessionEntity? session;
  final String? errorMessage;

  ReviewDetailState copyWith({
    ReviewLoadStatus? status,
    ReviewSessionEntity? session,
    String? errorMessage,
  }) {
    return ReviewDetailState(
      sessionId: sessionId,
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ReviewDetailState.initial(String sessionId) {
    return ReviewDetailState(
      sessionId: sessionId,
      status: ReviewLoadStatus.initial,
    );
  }
}

class ReviewDetailController extends StateNotifier<ReviewDetailState> {
  ReviewDetailController(this._useCase)
      : super(ReviewDetailState.initial(''));

  final GetReviewSessionById _useCase;

  Future<void> load(String sessionId) async {
    if (state.status == ReviewLoadStatus.loading && sessionId == state.sessionId) {
      return;
    }
    state = ReviewDetailState(
      sessionId: sessionId,
      status: ReviewLoadStatus.loading,
    );
    final Result<ReviewSessionEntity?> result = await _useCase(sessionId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: ReviewLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (ReviewSessionEntity? session) {
        state = ReviewDetailState(
          sessionId: sessionId,
          status: ReviewLoadStatus.ready,
          session: session,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Review list state — controlled by an active filter.
// ---------------------------------------------------------------------------

enum ReviewLoadStatus { initial, loading, ready, error }

@immutable
class ReviewListState {
  const ReviewListState({
    required this.filter,
    required this.status,
    required this.questions,
    required this.sessions,
    this.errorMessage,
    this.statistics,
  });

  final ReviewFilter filter;
  final ReviewLoadStatus status;
  final List<ReviewQuestionEntity> questions;
  final List<ReviewSessionEntity> sessions;
  final String? errorMessage;
  final ReviewStatistics? statistics;

  ReviewListState copyWith({
    ReviewFilter? filter,
    ReviewLoadStatus? status,
    List<ReviewQuestionEntity>? questions,
    List<ReviewSessionEntity>? sessions,
    String? errorMessage,
    ReviewStatistics? statistics,
  }) {
    return ReviewListState(
      filter: filter ?? this.filter,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage ?? this.errorMessage,
      statistics: statistics ?? this.statistics,
    );
  }

  static const ReviewListState initial = ReviewListState(
    filter: ReviewFilter.all,
    status: ReviewLoadStatus.initial,
    questions: <ReviewQuestionEntity>[],
    sessions: <ReviewSessionEntity>[],
  );
}

/// Aggregate stats derived from the loaded sessions; used by the
/// statistics card on the Review screen.
@immutable
class ReviewStatistics {
  const ReviewStatistics({
    required this.totalAttempts,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.bookmarkCount,
    required this.timeSpentSeconds,
  });

  final int totalAttempts;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int bookmarkCount;
  final int timeSpentSeconds;

  double get accuracy {
    final int answered = correctCount + incorrectCount;
    if (answered == 0) return 0;
    return correctCount / answered;
  }

  factory ReviewStatistics.from(List<ReviewSessionEntity> sessions) {
    int totalAttempts = 0;
    int correctCount = 0;
    int incorrectCount = 0;
    int skippedCount = 0;
    int bookmarkCount = 0;
    int timeSpentSeconds = 0;
    for (final ReviewSessionEntity s in sessions) {
      totalAttempts += s.questions.length;
      correctCount += s.correctCount;
      incorrectCount += s.incorrectCount;
      skippedCount += s.skippedCount;
      bookmarkCount += s.bookmarkedCount;
      for (final ReviewQuestionEntity q in s.questions) {
        timeSpentSeconds += q.timeSpentSeconds;
      }
    }
    return ReviewStatistics(
      totalAttempts: totalAttempts,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      skippedCount: skippedCount,
      bookmarkCount: bookmarkCount,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}

class ReviewListController extends StateNotifier<ReviewListState> {
  ReviewListController({
    required GetAllReviewSessions getSessions,
    required GetQuestionsForFilter getQuestionsForFilter,
  })  : _getSessions = getSessions,
        _getQuestionsForFilter = getQuestionsForFilter,
        super(ReviewListState.initial);

  final GetAllReviewSessions _getSessions;
  final GetQuestionsForFilter _getQuestionsForFilter;

  Future<void> load({ReviewFilter? filter}) async {
    final ReviewFilter target = filter ?? state.filter;
    if (state.status == ReviewLoadStatus.loading && target == state.filter) {
      return;
    }
    state = state.copyWith(
      filter: target,
      status: ReviewLoadStatus.loading,
    );

    final Result<List<ReviewSessionEntity>> sessionsResult =
        await _getSessions();
    final Result<List<ReviewQuestionEntity>> questionsResult =
        await _getQuestionsForFilter(target);

    if (sessionsResult.isFailure) {
      state = state.copyWith(
        status: ReviewLoadStatus.error,
        errorMessage: sessionsResult.failureOrNull?.message,
        questions: const <ReviewQuestionEntity>[],
        sessions: const <ReviewSessionEntity>[],
        statistics: null,
      );
      return;
    }

    final List<ReviewSessionEntity> sessions = List<ReviewSessionEntity>.unmodifiable(
      sessionsResult.valueOrNull ?? <ReviewSessionEntity>[],
    );
    final List<ReviewQuestionEntity> questions = questionsResult.isSuccess
        ? List<ReviewQuestionEntity>.unmodifiable(
            questionsResult.valueOrNull ?? <ReviewQuestionEntity>[],
          )
        : <ReviewQuestionEntity>[];

    state = ReviewListState(
      filter: target,
      status: ReviewLoadStatus.ready,
      questions: questions,
      sessions: sessions,
      statistics: ReviewStatistics.from(sessions),
      errorMessage: questionsResult.isFailure
          ? questionsResult.failureOrNull?.message
          : null,
    );
  }

  Future<void> setFilter(ReviewFilter filter) async {
    if (filter == state.filter &&
        state.status == ReviewLoadStatus.ready) {
      return;
    }
    await load(filter: filter);
  }
}

final StateNotifierProvider<ReviewListController, ReviewListState>
    reviewListControllerProvider =
    StateNotifierProvider<ReviewListController, ReviewListState>((Ref ref) {
  return ReviewListController(
    getSessions: ref.watch(getAllReviewSessionsProvider),
    getQuestionsForFilter: ref.watch(getQuestionsForFilterProvider),
  );
});

// ---------------------------------------------------------------------------
// Bookmark set state — mirrors server-side bookmark ids for the UI.
// ---------------------------------------------------------------------------

@immutable
class ReviewBookmarkState {
  const ReviewBookmarkState({
    required this.ids,
    this.errorMessage,
  });

  final Set<String> ids;
  final String? errorMessage;

  bool contains(String id) => ids.contains(id);

  ReviewBookmarkState copyWith({
    Set<String>? ids,
    String? errorMessage,
  }) {
    return ReviewBookmarkState(
      ids: ids ?? this.ids,
      errorMessage: errorMessage,
    );
  }

  static const ReviewBookmarkState initial =
      ReviewBookmarkState(ids: <String>{});
}

class ReviewBookmarkController extends StateNotifier<ReviewBookmarkState> {
  ReviewBookmarkController(this._toggle)
      : super(ReviewBookmarkState.initial);

  final ToggleBookmark _toggle;

  Future<void> prime(Set<String> ids) async {
    state = state.copyWith(ids: Set<String>.unmodifiable(ids));
  }

  Future<void> toggle(String questionId) async {
    final Set<String> previous = Set<String>.of(state.ids);
    final Set<String> optimistic = Set<String>.of(state.ids);
    if (optimistic.contains(questionId)) {
      optimistic.remove(questionId);
    } else {
      optimistic.add(questionId);
    }
    state = state.copyWith(ids: Set<String>.unmodifiable(optimistic));

    final Result<bool> result = await _toggle(questionId);
    result.fold(
      onFailure: (_) {
        state = state.copyWith(ids: Set<String>.unmodifiable(previous));
      },
      onSuccess: (bool added) {
        final Set<String> next = Set<String>.of(state.ids);
        if (added) {
          next.add(questionId);
        } else {
          next.remove(questionId);
        }
        state = state.copyWith(ids: Set<String>.unmodifiable(next));
      },
    );
  }
}

final StateNotifierProvider<ReviewBookmarkController, ReviewBookmarkState>
    reviewBookmarkControllerProvider =
    StateNotifierProvider<ReviewBookmarkController, ReviewBookmarkState>(
        (Ref ref) {
  return ReviewBookmarkController(ref.watch(toggleBookmarkProvider));
});

// ---------------------------------------------------------------------------
// AI explanation state — keyed by question id.
// ---------------------------------------------------------------------------

enum ReviewAiLoadStatus { idle, loading, ready, error }

@immutable
class AiExplanationState {
  const AiExplanationState({
    required this.status,
    this.explanation,
    this.errorMessage,
  });

  final ReviewAiLoadStatus status;
  final String? explanation;
  final String? errorMessage;

  AiExplanationState copyWith({
    ReviewAiLoadStatus? status,
    String? explanation,
    String? errorMessage,
  }) {
    return AiExplanationState(
      status: status ?? this.status,
      explanation: explanation ?? this.explanation,
      errorMessage: errorMessage,
    );
  }

  static const AiExplanationState initial =
      AiExplanationState(status: ReviewAiLoadStatus.idle);
}

class AiExplanationController extends StateNotifier<AiExplanationState> {
  AiExplanationController(this._useCase) : super(AiExplanationState.initial);

  final GetAiExplanation _useCase;

  Future<void> load(String questionId) async {
    if (state.status == ReviewAiLoadStatus.loading) return;
    state = state.copyWith(status: ReviewAiLoadStatus.loading);
    final Result<String> result = await _useCase(questionId);
    result.fold(
      onFailure: (failure) {
        state = AiExplanationState(
          status: ReviewAiLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (String value) {
        state = AiExplanationState(
          status: ReviewAiLoadStatus.ready,
          explanation: value,
        );
      },
    );
  }

  void reset() {
    state = AiExplanationState.initial;
  }
}

final StateNotifierProviderFamily<AiExplanationController, AiExplanationState,
        String>
    aiExplanationControllerProvider =
    StateNotifierProvider.family<AiExplanationController, AiExplanationState,
        String>((Ref ref, String questionId) {
  return AiExplanationController(ref.watch(getAiExplanationProvider));
});