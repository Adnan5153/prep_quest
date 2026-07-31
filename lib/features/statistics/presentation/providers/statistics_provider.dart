import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/statistics_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/user_statistics_entity.dart';
import '../../domain/enums/statistics_enums.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/get_accuracy_statistics.dart';
import '../../domain/usecases/get_statistics.dart';
import '../../domain/usecases/get_study_statistics.dart';
import '../utils/statistics_visual_mapper.dart';

// ---------------------------------------------------------------------------
// Repository + use cases
// ---------------------------------------------------------------------------

/// Statistics feature uses the realtime [StatisticsService] directly —
/// it reads from Firestore via `users/{uid}/statistics/current` and
/// `users/{uid}/category_progress/{categoryId}` and does not need a
/// separate remote datasource wrapper. The repository is a thin
/// facade over the service.
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepositoryImpl(
    service: ref.watch(statisticsServiceProvider),
  );
});

final getStatisticsUseCaseProvider = Provider<GetStatistics>(
  (ref) => GetStatistics(ref.watch(statisticsRepositoryProvider)),
);

final getAccuracyStatisticsUseCaseProvider =
    Provider<GetAccuracyStatistics>(
  (ref) => GetAccuracyStatistics(ref.watch(statisticsRepositoryProvider)),
);

final getStudyStatisticsUseCaseProvider = Provider<GetStudyStatistics>(
  (ref) => GetStudyStatistics(ref.watch(statisticsRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// Realtime streams — autoDispose so they tear down with the screen.
// ---------------------------------------------------------------------------

/// Auth-aware realtime provider for the global statistics row.
final userStatisticsLiveProvider =
    StreamProvider.autoDispose<UserStatisticsEntity>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<UserStatisticsEntity>.value(UserStatisticsEntity.empty);
  }
  return ref.watch(statisticsServiceProvider).watch(uid);
});

/// Auth-aware realtime provider for the per-category breakdown.
final categoryStatisticsLiveProvider =
    StreamProvider.autoDispose<List<CategoryStatisticsEntity>>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<List<CategoryStatisticsEntity>>.value(
      const <CategoryStatisticsEntity>[],
    );
  }
  return ref.watch(statisticsServiceProvider).watchCategories(uid);
});

// ---------------------------------------------------------------------------
// Controller state + state machine
// ---------------------------------------------------------------------------

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
  StatisticsController({
    required GetStatistics getStatistics,
    required StatisticsService service,
    required this.ref,
  })  : _getStatistics = getStatistics,
        _service = service,
        super(StatisticsState.initial) {
    _subscribe();
  }

  final GetStatistics _getStatistics;
  final StatisticsService _service;
  final Ref ref;

  StreamSubscription<UserStatisticsEntity>? _userSub;
  StreamSubscription<List<CategoryStatisticsEntity>>? _categorySub;
  String _watchedUid = '';
  final bool _suspended = false;

  /// Starts (or restarts) the realtime subscription so the controller
  /// state mirrors the latest Firestore writes.
  void _subscribe() {
    final auth = ref.read(authStateProvider);
    final String uid = auth.user?.id ?? '';
    if (uid == _watchedUid) return;
    _watchedUid = uid;
    _userSub?.cancel();
    _categorySub?.cancel();
    if (uid.isEmpty) {
      return;
    }
    _userSub = _service.watch(uid).listen((UserStatisticsEntity next) {
      _applyUserStats(next);
    });
    _categorySub =
        _service.watchCategories(uid).listen((List<CategoryStatisticsEntity> rows) {
      _applyCategoryStats(rows);
    });
  }

  Future<void> _applyUserStats(UserStatisticsEntity stats) async {
    if (_suspended) return;
    state = state.copyWith(status: StatisticsLoadStatus.ready);
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

  Future<void> _applyCategoryStats(
      List<CategoryStatisticsEntity> rows) async {
    if (_suspended) return;
    // Trigger a rebuild through the same legacy path so the
    // subject breakdown reflects the new rows.
    await _applyUserStats(UserStatisticsEntity.empty);
  }

  Future<void> load({bool forceRefresh = false}) async {
    _subscribe();
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

  @override
  void dispose() {
    _userSub?.cancel();
    _categorySub?.cancel();
    super.dispose();
  }
}

final statisticsControllerProvider =
    StateNotifierProvider<StatisticsController, StatisticsState>((ref) {
  return StatisticsController(
    getStatistics: ref.watch(getStatisticsUseCaseProvider),
    service: ref.watch(statisticsServiceProvider),
    ref: ref,
  );
});

final statisticsVisualProvider = Provider<StatisticsVisual?>((ref) {
  return ref.watch(statisticsControllerProvider).visual;
});

final statisticsRangeProvider = Provider<StatisticsRange>((ref) {
  return ref.watch(statisticsControllerProvider).selectedRange;
});
