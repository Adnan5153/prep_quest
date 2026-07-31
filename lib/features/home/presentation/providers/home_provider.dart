import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';
import '../../../gamification/presentation/providers/mission_provider.dart';
import '../../../gamification/presentation/providers/streak_provider.dart';
import '../../../profile/domain/entities/coin_transaction.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/coin_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../profile/presentation/states/profile_state.dart';

/// Aggregate snapshot of everything the Home dashboard needs to
/// render. Built by [homeControllerProvider] from existing
/// `profileControllerProvider`, `streakControllerProvider`,
/// `missionsControllerProvider`, and `coinHistoryProvider` so the
/// home screen always sees a single, stable view of the world.
@immutable
class HomeSnapshot {
  const HomeSnapshot({
    required this.profile,
    required this.streakDays,
    required this.streakAtRisk,
    required this.missions,
    required this.coinLedger,
    required this.continueLearning,
    required this.isPremium,
  });

  final UserProfile? profile;
  final int streakDays;
  final bool streakAtRisk;
  final MissionsViewState missions;
  final List<CoinTransactionEntity> coinLedger;
  final CategoryEntity? continueLearning;
  final bool isPremium;

  bool get isAuthenticated => profile != null;
  bool get hasRecentActivity => coinLedger.isNotEmpty;
  bool get hasIncompleteMission =>
      missions.daily.isNotEmpty ||
      missions.weekly.isNotEmpty ||
      missions.monthly.isNotEmpty;

  static const HomeSnapshot empty = HomeSnapshot(
    profile: null,
    streakDays: 0,
    streakAtRisk: false,
    missions: MissionsViewState.initial,
    coinLedger: <CoinTransactionEntity>[],
    continueLearning: null,
    isPremium: false,
  );
}

/// One-shot view of the home dashboard. Re-emits whenever any of the
/// underlying providers fire. The screen watches this so it never
/// has to coordinate four `ref.watch` calls of its own.
final homeControllerProvider = Provider<AsyncValue<HomeSnapshot>>((ref) {
  final ProfileState profileState = ref.watch(profileControllerProvider);
  final StreakViewState streakView = ref.watch(streakControllerProvider);
  final MissionsViewState missions = ref.watch(missionsControllerProvider);
  final AsyncValue<List<CoinTransactionEntity>> ledgerAsync =
      ref.watch(coinHistoryProvider);
  final AsyncValue<List<CategoryEntity>> categoriesAsync =
      ref.watch(categoriesStreamProvider);

  final List<CoinTransactionEntity> ledger = ledgerAsync.maybeWhen(
    data: (List<CoinTransactionEntity> data) => data,
    orElse: () => const <CoinTransactionEntity>[],
  );

  final CategoryEntity? continueLearning = _pickContinueLearning(
    categories: categoriesAsync.maybeWhen(
      data: (List<CategoryEntity> data) => data,
      orElse: () => const <CategoryEntity>[],
    ),
  );

  return AsyncValue<HomeSnapshot>.data(
    HomeSnapshot(
      profile: profileState.profile,
      streakDays: streakView.snapshot.currentDays,
      streakAtRisk: streakView.snapshot.isAtRisk,
      missions: missions,
      coinLedger: ledger,
      continueLearning: continueLearning,
      isPremium: profileState.profile?.role == 'premium',
    ),
  );
});

CategoryEntity? _pickContinueLearning({
  required List<CategoryEntity> categories,
}) {
  if (categories.isEmpty) return null;
  final List<CategoryEntity> sorted = <CategoryEntity>[...categories]
    ..sort((CategoryEntity a, CategoryEntity b) => a.order.compareTo(b.order));
  // Prefer the first lesson / mock-test category. Milestones and
  // rewards are surfaced elsewhere (Library, Daily Reward sheet).
  for (final CategoryEntity c in sorted) {
    if (c.kind == CategoryNodeKind.lesson ||
        c.kind == CategoryNodeKind.mockTest) {
      return c;
    }
  }
  return sorted.first;
}