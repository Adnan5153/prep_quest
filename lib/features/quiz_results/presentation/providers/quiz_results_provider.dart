import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../../../quiz_engine/presentation/providers/quiz_providers.dart';
import '../../data/datasources/mock_quiz_results_remote_datasource.dart';
import '../../data/datasources/quiz_results_remote_datasource.dart';
import '../../data/repositories/quiz_results_repository_impl.dart';
import '../../domain/entities/quiz_performance_entity.dart';
import '../../domain/repositories/quiz_results_repository.dart';
import '../../domain/usecases/calculate_rewards.dart';
import '../../domain/usecases/get_quiz_performance.dart';
import '../../domain/usecases/retry_quiz.dart';

final quizResultsRemoteDataSourceProvider =
    Provider<QuizResultsRemoteDataSource>((ref) {
  return MockQuizResultsRemoteDataSource(
    ref.watch(quizRemoteDataSourceProvider),
  );
});

final quizResultsRepositoryProvider = Provider<QuizResultsRepository>((ref) {
  return QuizResultsRepositoryImpl(ref.watch(quizResultsRemoteDataSourceProvider));
});

final getQuizPerformanceProvider = Provider<GetQuizPerformance>((ref) {
  return GetQuizPerformance(ref.watch(quizResultsRepositoryProvider));
});

final retryQuizProvider = Provider<RetryQuiz>((ref) {
  return RetryQuiz(ref.watch(quizResultsRepositoryProvider));
});

final calculateRewardsProvider = Provider<CalculateRewards>((ref) {
  return const CalculateRewards();
});

@immutable
class QuizResultsState {
  const QuizResultsState({
    required this.status,
    this.performance,
    this.errorMessage,
  });

  final QuizResultsLoadStatus status;
  final QuizPerformanceEntity? performance;
  final String? errorMessage;

  QuizResultsState copyWith({
    QuizResultsLoadStatus? status,
    QuizPerformanceEntity? performance,
    String? errorMessage,
  }) {
    return QuizResultsState(
      status: status ?? this.status,
      performance: performance ?? this.performance,
      errorMessage: errorMessage,
    );
  }

  static const QuizResultsState initial = QuizResultsState(
    status: QuizResultsLoadStatus.initial,
  );
}

enum QuizResultsLoadStatus { initial, loading, ready, error }

class QuizResultsController extends StateNotifier<QuizResultsState> {
  QuizResultsController(this._getQuizPerformance, this._retryQuiz)
      : super(QuizResultsState.initial);

  final GetQuizPerformance _getQuizPerformance;
  final RetryQuiz _retryQuiz;

  Future<void> load({
    required String quizId,
    required QuizSessionEntity session,
  }) async {
    if (state.status == QuizResultsLoadStatus.loading) return;
    state = state.copyWith(status: QuizResultsLoadStatus.loading);
    final Result<QuizPerformanceEntity> result = await _getQuizPerformance(
      quizId: quizId,
      session: session,
    );
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: QuizResultsLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (performance) {
        state = QuizResultsState(
          status: QuizResultsLoadStatus.ready,
          performance: performance,
        );
      },
    );
  }

  Future<QuizSessionEntity?> retry(String quizId) async {
    final Result<QuizSessionEntity> result = await _retryQuiz(quizId);
    return result.fold(
      onFailure: (_) => null,
      onSuccess: (session) => session,
    );
  }
}

final quizResultsControllerProvider = StateNotifierProvider.family<
  QuizResultsController,
  QuizResultsState,
  String
>((ref, quizId) {
  return QuizResultsController(
    ref.watch(getQuizPerformanceProvider),
    ref.watch(retryQuizProvider),
  );
});
