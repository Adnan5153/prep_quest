import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ai_tutor/presentation/providers/ai_tutor_provider.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/states/auth_state.dart';
import '../../features/bookmarks/presentation/providers/bookmark_provider.dart';
import '../../features/gamification/presentation/providers/mission_provider.dart';
import '../../features/gamification/presentation/providers/rewards_provider.dart';
import '../../features/gamification/presentation/providers/streak_provider.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import '../../features/leaderboard/presentation/providers/leaderboard_provider.dart';
import '../../features/notes/presentation/providers/notes_provider.dart';
import '../../features/notifications/presentation/providers/notification_provider.dart';
import '../../features/offline/presentation/providers/sync_provider.dart';
import '../../features/playground/presentation/providers/playground_categories_provider.dart';
import '../../features/playground/presentation/providers/playground_providers.dart';
import '../../features/playground/presentation/providers/world_steps_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/search/presentation/providers/search_provider.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../../features/statistics/presentation/providers/statistics_provider.dart';
import '../../features/subscription/presentation/providers/subscription_provider.dart';

/// Provider that resets all user-bound feature providers whenever the
/// auth state transitions to an unauthenticated user.
///
/// Phase 51 — every provider that holds user data should `ref.listen`
/// on this provider and call `ref.invalidateSelf()` so cached state
/// does not leak across accounts. The list of providers is
/// hard-coded so the lifecycle is explicit and reviewable.
///
/// Usage in a feature provider factory:
///
/// ```dart
/// final myControllerProvider = StateNotifierProvider<MyController, MyState>(
///   (Ref ref) {
///     ref.listen(authStateResetProvider, (_, __) => ref.invalidateSelf());
///     return MyController(...);
///   },
/// );
/// ```
final Provider<void> authStateResetProvider = Provider<void>((Ref ref) {
  ref.listen<AuthState>(
    authStateProvider,
    (AuthState? previous, AuthState next) {
      if (next.user == null) {
        ref.invalidate(_authStateResetDispatcherProvider);
      }
    },
  );
});

/// Internal dispatcher that fans out to the list of providers needing
/// reset on logout. Lives in its own provider so the [ref.invalidate]
/// call site is well-typed.
final Provider<void> _authStateResetDispatcherProvider = Provider<void>((Ref ref) {
  final List<ProviderListenable<Object?>> providers = <ProviderListenable<Object?>>[
    bookmarkControllerProvider,
    notesControllerProvider,
    notificationControllerProvider,
    profileControllerProvider,
    rewardsControllerProvider,
    streakControllerProvider,
    missionsControllerProvider,
    leaderboardControllerProvider,
    statisticsControllerProvider,
    aiHistoryControllerProvider,
    searchControllerProvider,
    subscriptionControllerProvider,
    syncControllerProvider,
    settingsControllerProvider,
    homeControllerProvider,
    playgroundProgressProvider,
    worldStepsProvider,
    playgroundCategoriesProvider,
  ];
  for (final ProviderListenable<Object?> p in providers) {
    try {
      ref.invalidate(p as ProviderOrFamily);
    } catch (_) {
      // Best-effort — providers that aren't alive in the current
      // container just get skipped.
    }
  }
});