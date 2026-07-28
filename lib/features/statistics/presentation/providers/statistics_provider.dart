import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/mock_statistics_remote_datasource.dart';
import '../../data/datasources/statistics_remote_datasource.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/enums/statistics_enums.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/get_accuracy_statistics.dart';
import '../../domain/usecases/get_statistics.dart';
import '../../domain/usecases/get_study_statistics.dart';
import '../utils/statistics_visual_mapper.dart';

final statisticsRemoteDataSourceProvider =
    Provider<StatisticsRemoteDataSource>((ref) {
  return MockStatisticsRemoteDataSource();
});

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepositoryImpl(ref.watch(statisticsRemoteDataSourceProvider));
});

final getStatisticsUseCaseProvider = Provider<GetStatistics>((ref) {
  return GetStatistics(ref.watch(statisticsRepositoryProvider));
});

final getAccuracyStatisticsUseCaseProvider =
    Provider<GetAccuracyStatistics>((ref) {
  return GetAccuracyStatistics(ref.watch(statisticsRepositoryProvider));
});

final getStudyStatisticsUseCaseProvider = Provider<GetStudyStatistics>((ref) {
  return GetStudyStatistics(ref.watch(statisticsRepositoryProvider));
});

@immutable
class StatisticsState {
  const StatisticsState({
    required this.status,
    this.visual,
    this.errorMessage,
    this.selectedRange = StatisticsRange.weekly,
  });

  final StatisticsLoadStatus status;
  final StatisticsVisual? visual;
  final String? errorMessage;
  final StatisticsRange selectedRange;

  bool get isLoading => status == StatisticsLoadStatus.loading;
  bool get isReady => status == StatisticsLoadStatus.ready;
  bool get isError => status == StatisticsLoadStatus.error;
  bool get isEmpty =>
      isReady && (visual == null || _allZeros(visual!));

  static bool _allZeros(StatisticsVisual v) =>
      v.totalXp == 0 &&
      v.accuracy.overallPercent == 0 &&
      v.study.todayMinutes == 0 &&
      v.weeklyActivity.every((c) => c.value == 0);

  StatisticsState copyWith({
    StatisticsLoadStatus? status,
    StatisticsVisual? visual,
    String? errorMessage,
    StatisticsRange? selectedRange,
    bool clearError = false,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      visual: visual ?? this.visual,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedRange: selectedRange ?? this.selectedRange,
    );
  }

  static const StatisticsState initial = StatisticsState(
    status: StatisticsLoadStatus.initial,
  );
}

class StatisticsController extends StateNotifier<StatisticsState> {
  StatisticsController(this._getStatistics)
      : super(StatisticsState.initial);

  final GetStatistics _getStatistics;

  Future<void> load({bool forceRefresh = false}) async {
    if (state.status == StatisticsLoadStatus.loading) return;
    if (!forceRefresh && state.visual != null) {
      state = state.copyWith(status: StatisticsLoadStatus.ready);
      return;
    }
    state = state.copyWith(
      status: StatisticsLoadStatus.loading,
      clearError: true,
    );
    final Result<StatisticsEntity> result = await _getStatistics();
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: StatisticsLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (stats) {
        final StatisticsVisual visual = StatisticsVisualMapper.toVisual(stats);
        state = StatisticsState(
          status: StatisticsLoadStatus.ready,
          visual: visual,
          selectedRange: state.selectedRange,
        );
      },
    );
  }

  void setRange(StatisticsRange range) {
    if (state.selectedRange == range) return;
    state = state.copyWith(selectedRange: range);
  }

  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(clearError: true);
  }
}

final statisticsControllerProvider =
    StateNotifierProvider<StatisticsController, StatisticsState>((ref) {
  return StatisticsController(ref.watch(getStatisticsUseCaseProvider));
});

final statisticsVisualProvider = Provider<StatisticsVisual?>((ref) {
  return ref.watch(statisticsControllerProvider).visual;
});

final statisticsRangeProvider = Provider<StatisticsRange>((ref) {
  return ref.watch(statisticsControllerProvider).selectedRange;
});