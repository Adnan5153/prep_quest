import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/datasources/leaderboard_local_datasource.dart';
import '../../data/datasources/leaderboard_remote_datasource.dart';
import '../../data/repositories/leaderboard_repository_impl.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../../domain/usecases/get_friends_leaderboard.dart';
import '../../domain/usecases/get_national_leaderboard.dart';
import '../../domain/usecases/get_seasonal_leaderboard.dart';
import '../../domain/usecases/get_university_leaderboard.dart';
import '../../domain/usecases/get_weekly_leaderboard.dart';

/// Provides the deterministic in-memory datasource.
final leaderboardLocalDataSourceProvider =
    Provider<LeaderboardLocalDataSource>(
  (ref) => LeaderboardLocalDataSource(),
);

/// Firestore-backed remote datasource. Falls back to empty rows when
/// Firebase is unavailable; the repository then serves the local
/// preview so the existing UI never breaks.
final leaderboardRemoteDataSourceProvider =
    Provider<LeaderboardRemoteDataSource>(
  (ref) => LeaderboardRemoteDataSource(),
);

/// Single repository the entire feature consumes. Remote-first for
/// authenticated users; guest / offline requests transparently fall
/// back to the deterministic local preview.
final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => LeaderboardRepositoryImpl(
    local: ref.watch(leaderboardLocalDataSourceProvider),
    remote: ref.watch(leaderboardRemoteDataSourceProvider),
    preferRemote: true,
    uidProvider: () => ref.read(authStateProvider).user?.id ?? '',
  ),
);

final getFriendsLeaderboardUseCaseProvider = Provider<GetFriendsLeaderboard>(
  (ref) => GetFriendsLeaderboard(ref.watch(leaderboardRepositoryProvider)),
);
final getUniversityLeaderboardUseCaseProvider =
    Provider<GetUniversityLeaderboard>(
  (ref) => GetUniversityLeaderboard(ref.watch(leaderboardRepositoryProvider)),
);
final getNationalLeaderboardUseCaseProvider = Provider<GetNationalLeaderboard>(
  (ref) => GetNationalLeaderboard(ref.watch(leaderboardRepositoryProvider)),
);
final getWeeklyLeaderboardUseCaseProvider = Provider<GetWeeklyLeaderboard>(
  (ref) => GetWeeklyLeaderboard(ref.watch(leaderboardRepositoryProvider)),
);
final getSeasonalLeaderboardUseCaseProvider = Provider<GetSeasonalLeaderboard>(
  (ref) => GetSeasonalLeaderboard(ref.watch(leaderboardRepositoryProvider)),
);

/// Hub mode: show every scope as a card OR a single expanded scope.
enum LeaderboardHubMode { overview, detail }

/// Top-level view state for the leaderboard hub.
@immutable
class LeaderboardViewState {
  const LeaderboardViewState({
    required this.status,
    required this.mode,
    required this.activeScope,
    required this.sort,
    required this.query,
    this.categories = const <LeaderboardCategoryEntity>[],
    this.entries = const <LeaderboardEntryEntity>[],
    this.errorMessage,
  });

  final LeaderboardStatus status;
  final LeaderboardHubMode mode;
  final LeaderboardScope? activeScope;
  final LeaderboardSort sort;
  final String query;
  final List<LeaderboardCategoryEntity> categories;
  final List<LeaderboardEntryEntity> entries;
  final String? errorMessage;

  bool get isLoading => status == LeaderboardStatus.loading;
  bool get isReady => status == LeaderboardStatus.ready;
  bool get isOverview => mode == LeaderboardHubMode.overview;

  /// Returns the category matching [activeScope] in overview mode,
  /// or the single category in detail mode.
  LeaderboardCategoryEntity? get activeCategory {
    if (activeScope == null) return null;
    for (final LeaderboardCategoryEntity c in categories) {
      if (c.scope == activeScope) return c;
    }
    return null;
  }

  /// Entries filtered by [query] (username / university) and re-sorted
  /// according to [sort].
  List<LeaderboardEntryEntity> get visibleEntries {
    final List<LeaderboardEntryEntity> filtered = query.isEmpty
        ? List<LeaderboardEntryEntity>.from(entries)
        : entries
            .where((LeaderboardEntryEntity e) =>
                e.username.toLowerCase().contains(query.toLowerCase()) ||
                e.university.toLowerCase().contains(query.toLowerCase()))
            .toList(growable: false);
    final List<LeaderboardEntryEntity> sorted =
        List<LeaderboardEntryEntity>.from(filtered);
    switch (sort) {
      case LeaderboardSort.rank:
        sorted.sort((LeaderboardEntryEntity a, LeaderboardEntryEntity b) =>
            a.rank.compareTo(b.rank));
      case LeaderboardSort.xp:
        sorted.sort((LeaderboardEntryEntity a, LeaderboardEntryEntity b) =>
            b.xp.compareTo(a.xp));
      case LeaderboardSort.coins:
        sorted.sort((LeaderboardEntryEntity a, LeaderboardEntryEntity b) =>
            b.coins.compareTo(a.coins));
      case LeaderboardSort.streak:
        sorted.sort((LeaderboardEntryEntity a, LeaderboardEntryEntity b) =>
            b.streakDays.compareTo(a.streakDays));
      case LeaderboardSort.level:
        sorted.sort((LeaderboardEntryEntity a, LeaderboardEntryEntity b) =>
            b.level.compareTo(a.level));
    }
    return List<LeaderboardEntryEntity>.unmodifiable(sorted);
  }

  LeaderboardViewState copyWith({
    LeaderboardStatus? status,
    LeaderboardHubMode? mode,
    LeaderboardScope? activeScope,
    bool clearActiveScope = false,
    LeaderboardSort? sort,
    String? query,
    List<LeaderboardCategoryEntity>? categories,
    List<LeaderboardEntryEntity>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LeaderboardViewState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      activeScope:
          clearActiveScope ? null : (activeScope ?? this.activeScope),
      sort: sort ?? this.sort,
      query: query ?? this.query,
      categories: categories ?? this.categories,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const LeaderboardViewState initial = LeaderboardViewState(
    status: LeaderboardStatus.initial,
    mode: LeaderboardHubMode.overview,
    activeScope: null,
    sort: LeaderboardSort.rank,
    query: '',
  );
}

enum LeaderboardStatus { initial, loading, ready, error }

/// State notifier for the leaderboard feature.
///
/// Subscribers read [leaderboardControllerProvider] for the live
/// view state; they call methods on the notifier to mutate it.
///
/// Phase 44: subscribes to [leaderboardCategoryStreamProvider] so
/// every Firestore write from `LeaderboardService.recordQuizCompletion`
/// surfaces inside the UI without an explicit refresh.
class LeaderboardController extends StateNotifier<LeaderboardViewState> {
  LeaderboardController({
    required this.repository,
    required Ref ref,
  }) : super(LeaderboardViewState.initial) {
    _ref = ref;
    for (final LeaderboardScope scope in LeaderboardScope.values) {
      _ref.listen<AsyncValue<LeaderboardCategoryEntity>>(
        leaderboardCategoryStreamProvider(scope),
        (
          AsyncValue<LeaderboardCategoryEntity>? previous,
          AsyncValue<LeaderboardCategoryEntity> next,
        ) {
          next.whenData((LeaderboardCategoryEntity category) {
            _upsertCategory(category);
          });
        },
      );
    }
  }

  final LeaderboardRepository repository;
  late final Ref _ref;
  final Map<LeaderboardScope, LeaderboardCategoryEntity> _liveCategories =
      <LeaderboardScope, LeaderboardCategoryEntity>{};

  void _upsertCategory(LeaderboardCategoryEntity category) {
    _liveCategories[category.scope] = category;
    final List<LeaderboardCategoryEntity> next = <LeaderboardCategoryEntity>[];
    for (final LeaderboardScope s in LeaderboardScope.values) {
      if (_liveCategories.containsKey(s)) {
        next.add(_liveCategories[s]!);
      }
    }
    if (!mounted) return;
    if (next.isNotEmpty) {
      state = state.copyWith(
        status: LeaderboardStatus.ready,
        categories: next,
        entries: state.activeScope == category.scope
            ? category.entries
            : state.entries,
        clearError: true,
      );
    }
  }

  /// Loads every scope in parallel — used by the hub.
  Future<void> loadAll() async {
    state = state.copyWith(status: LeaderboardStatus.loading, clearError: true);
    final Result<List<LeaderboardCategoryEntity>> result =
        await repository.fetchAll();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: LeaderboardStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (categories) {
        state = state.copyWith(
          status: LeaderboardStatus.ready,
          categories: categories,
          clearError: true,
        );
      },
    );
  }

  /// Loads a single scope — used by the detail screen.
  Future<void> loadScope(LeaderboardScope scope) async {
    state = state.copyWith(
      status: LeaderboardStatus.loading,
      mode: LeaderboardHubMode.detail,
      activeScope: scope,
      clearError: true,
    );
    final Result<LeaderboardCategoryEntity> result =
        await repository.fetch(scope);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: LeaderboardStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (category) {
        final List<LeaderboardCategoryEntity> categories =
            state.categories.any((LeaderboardCategoryEntity c) =>
                    c.scope == category.scope)
                ? state.categories
                    .map((LeaderboardCategoryEntity c) =>
                        c.scope == category.scope ? category : c)
                    .toList(growable: false)
                : <LeaderboardCategoryEntity>[...state.categories, category];
        state = state.copyWith(
          status: LeaderboardStatus.ready,
          categories: categories,
          entries: category.entries,
          clearError: true,
        );
      },
    );
  }

  /// Switches the active scope within detail mode.
  Future<void> selectScope(LeaderboardScope scope) async {
    await loadScope(scope);
  }

  /// Updates the sort key.
  void setSort(LeaderboardSort sort) {
    state = state.copyWith(sort: sort);
  }

  /// Updates the search query.
  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  /// Clears any surfaced error.
  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(clearError: true);
  }

  /// Returns to overview mode.
  void showOverview() {
    state = state.copyWith(
      mode: LeaderboardHubMode.overview,
      clearActiveScope: true,
      entries: const <LeaderboardEntryEntity>[],
    );
  }
}

final leaderboardControllerProvider =
    StateNotifierProvider<LeaderboardController, LeaderboardViewState>(
  (ref) => LeaderboardController(
    repository: ref.watch(leaderboardRepositoryProvider),
    ref: ref,
  ),
);

/// Convenience: the active scope's category.
final leaderboardActiveCategoryProvider =
    Provider<LeaderboardCategoryEntity?>(
  (ref) => ref.watch(leaderboardControllerProvider).activeCategory,
);

/// Convenience: the visible entries for the active scope.
final leaderboardVisibleEntriesProvider =
    Provider<List<LeaderboardEntryEntity>>(
  (ref) => ref.watch(leaderboardControllerProvider).visibleEntries,
);

/// Convenience: read-only snapshot of the active entries.
final leaderboardActiveEntriesProvider =
    Provider<List<LeaderboardEntryEntity>>(
  (ref) => ref.watch(leaderboardControllerProvider).entries,
);

/// Convenience: all loaded categories.
final leaderboardCategoriesProvider =
    Provider<List<LeaderboardCategoryEntity>>(
  (ref) => ref.watch(leaderboardControllerProvider).categories,
);
