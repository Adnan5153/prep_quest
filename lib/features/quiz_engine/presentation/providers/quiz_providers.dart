import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/mock_quiz_remote_datasource.dart';
import '../../data/datasources/quiz_remote_datasource.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/usecases/get_quiz_by_id.dart';
import '../../domain/usecases/get_quizzes.dart';
import '../../domain/usecases/report_question.dart';
import '../../domain/usecases/submit_quiz_session.dart';
import '../../domain/usecases/toggle_question_bookmark.dart';

final quizRemoteDataSourceProvider = Provider<QuizRemoteDataSource>((ref) {
  return MockQuizRemoteDataSource();
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepositoryImpl(ref.watch(quizRemoteDataSourceProvider));
});

final getQuizzesProvider = Provider<GetQuizzes>((ref) {
  return GetQuizzes(ref.watch(quizRepositoryProvider));
});

final getQuizzesForNodeProvider = Provider<GetQuizzesForNode>((ref) {
  return GetQuizzesForNode(ref.watch(quizRepositoryProvider));
});

final getQuizByIdProvider = Provider<GetQuizById>((ref) {
  return GetQuizById(ref.watch(quizRepositoryProvider));
});

final submitQuizSessionProvider = Provider<SubmitQuizSession>((ref) {
  return SubmitQuizSession(ref.watch(quizRepositoryProvider));
});

final reportQuestionProvider = Provider<ReportQuestion>((ref) {
  return ReportQuestion(ref.watch(quizRepositoryProvider));
});

final getBookmarkedQuestionIdsProvider = Provider<GetBookmarkedQuestionIds>((
  ref,
) {
  return GetBookmarkedQuestionIds(ref.watch(quizRepositoryProvider));
});

final toggleQuestionBookmarkProvider = Provider<ToggleQuestionBookmark>((ref) {
  return ToggleQuestionBookmark(ref.watch(quizRepositoryProvider));
});

enum QuizLoadStatus { initial, loading, ready, error }

@immutable
class QuizListState {
  const QuizListState({
    required this.status,
    required this.quizzes,
    this.errorMessage,
  });

  final QuizLoadStatus status;
  final List<QuizEntity> quizzes;
  final String? errorMessage;

  QuizListState copyWith({
    QuizLoadStatus? status,
    List<QuizEntity>? quizzes,
    String? errorMessage,
  }) {
    return QuizListState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      errorMessage: errorMessage,
    );
  }

  static const QuizListState initial = QuizListState(
    status: QuizLoadStatus.initial,
    quizzes: <QuizEntity>[],
  );
}

class QuizListController extends StateNotifier<QuizListState> {
  QuizListController(this._useCase) : super(QuizListState.initial);

  final GetQuizzes _useCase;

  Future<void> load() async {
    if (state.status == QuizLoadStatus.loading) return;
    state = state.copyWith(status: QuizLoadStatus.loading);
    final Result<List<QuizEntity>> result = await _useCase();
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: QuizLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (quizzes) {
        state = QuizListState(
          status: QuizLoadStatus.ready,
          quizzes: quizzes,
        );
      },
    );
  }
}

final quizListControllerProvider =
    StateNotifierProvider<QuizListController, QuizListState>((ref) {
      return QuizListController(ref.watch(getQuizzesProvider));
    });

@immutable
class QuizNodeState {
  const QuizNodeState({
    required this.nodeId,
    required this.status,
    required this.quizzes,
    this.errorMessage,
  });

  final String nodeId;
  final QuizLoadStatus status;
  final List<QuizEntity> quizzes;
  final String? errorMessage;

  QuizNodeState copyWith({
    QuizLoadStatus? status,
    List<QuizEntity>? quizzes,
    String? errorMessage,
  }) {
    return QuizNodeState(
      nodeId: nodeId,
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      errorMessage: errorMessage,
    );
  }

  static QuizNodeState initialFor(String nodeId) {
    return QuizNodeState(
      nodeId: nodeId,
      status: QuizLoadStatus.initial,
      quizzes: const <QuizEntity>[],
    );
  }
}

class QuizNodeController extends StateNotifier<QuizNodeState> {
  QuizNodeController(this._useCase, String nodeId)
    : super(QuizNodeState.initialFor(nodeId));

  final GetQuizzesForNode _useCase;

  Future<void> load(String nodeId) async {
    if (state.status == QuizLoadStatus.loading) return;
    state = QuizNodeState.initialFor(nodeId).copyWith(
      status: QuizLoadStatus.loading,
    );
    final Result<List<QuizEntity>> result = await _useCase(nodeId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: QuizLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (quizzes) {
        state = QuizNodeState(
          nodeId: nodeId,
          status: QuizLoadStatus.ready,
          quizzes: quizzes,
        );
      },
    );
  }
}

final quizNodeControllerProvider = StateNotifierProvider.family<
  QuizNodeController,
  QuizNodeState,
  String
>((ref, nodeId) {
  return QuizNodeController(ref.watch(getQuizzesForNodeProvider), nodeId);
});

@immutable
class QuizDetailState {
  const QuizDetailState({
    required this.quizId,
    required this.status,
    this.quiz,
    this.errorMessage,
  });

  final String quizId;
  final QuizLoadStatus status;
  final QuizEntity? quiz;
  final String? errorMessage;

  QuizDetailState copyWith({
    QuizLoadStatus? status,
    QuizEntity? quiz,
    String? errorMessage,
  }) {
    return QuizDetailState(
      quizId: quizId,
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      errorMessage: errorMessage,
    );
  }
}

class QuizDetailController extends StateNotifier<QuizDetailState> {
  QuizDetailController(this._useCase, String quizId)
    : super(QuizDetailState(
        quizId: quizId,
        status: QuizLoadStatus.initial,
      ));

  final GetQuizById _useCase;

  Future<void> load(String quizId) async {
    if (state.status == QuizLoadStatus.loading) return;
    state = QuizDetailState(quizId: quizId, status: QuizLoadStatus.loading);
    final Result<QuizEntity?> result = await _useCase(quizId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: QuizLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (quiz) {
        if (quiz == null) {
          state = state.copyWith(
            status: QuizLoadStatus.error,
            errorMessage: 'Quiz not found',
          );
        } else {
          state = QuizDetailState(
            quizId: quizId,
            status: QuizLoadStatus.ready,
            quiz: quiz,
          );
        }
      },
    );
  }
}

final quizDetailControllerProvider = StateNotifierProvider.family<
  QuizDetailController,
  QuizDetailState,
  String
>((ref, quizId) {
  return QuizDetailController(ref.watch(getQuizByIdProvider), quizId);
});