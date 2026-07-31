import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_strings.dart';
import 'core/services/level_up_event_bus.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/providers/auth_providers.dart';
import 'features/gamification/presentation/providers/level_reward_queue_provider.dart';
import 'features/playground/presentation/constants/playground_constants.dart';
import 'features/playground/presentation/widgets/level_reward_dialog.dart';
import 'router.dart';

/// Root widget for the Prep Quest application.
///
/// Responsibilities (kept deliberately small):
/// - Provide the top-level [MaterialApp.router] for the host application.
/// - Resolve theme + localization based on the active [AppConfig].
/// - Mount the [ProviderScope] so Riverpod-backed features (auth,
///   theme, language) can listen to state changes. The router is
///   produced from inside the scope so it can plug in the
///   [authRouterRefreshProvider] and keep the redirect logic in
///   sync with the auth state.
/// - Listen to the canonical [LevelUpEventBus] and pop the level-up
///   dialog on the root navigator whenever a quiz completion crosses
///   one or more level boundaries.
///
/// Anything that owns state, fetches data, or listens to streams lives in
/// the feature folders under `lib/features/<feature>/presentation/providers`.
class PrepQuestApp extends ConsumerWidget {
  const PrepQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfig config = AppConfig.instance;
    // Reading the auth refresh provider inside `build` ensures the
    // router is rebuilt whenever the auth state changes.
    final ValueNotifier<int> refreshListenable =
        ref.watch(authRouterRefreshProvider);

    ref.listen<LevelUpEvent?>(levelUpEventBusProvider, (
      LevelUpEvent? previous,
      LevelUpEvent? next,
    ) async {
      if (next == null) return;
      final NavigatorState navigator = Navigator.of(
        context,
        rootNavigator: true,
      );
      await LevelRewardDialog.show(
        context,
        visual: LevelRewardDialogVisual(
          levelNumber: next.toLevel,
          xpEarned: next.reward.xpBonus,
          coinsEarned: next.reward.coinBonus,
          badgeEarned: next.reward.badgeId,
          nextLevelNumber: next.toLevel + 1,
          unlockedTitles: next.reward.unlockedTitles,
          rarity: PlaygroundRarity.legendary,
          animate: true,
          showConfetti: true,
        ),
        onPrimary: () {
          ref.read(levelUpEventBusProvider.notifier).clear();
          ref
              .read(levelRewardQueueProvider.notifier)
              .markClaimed(next.reward);
        },
      );
      if (navigator.mounted) {
        // No-op; preserved as a checkpoint so the listener can be
        // extended with explicit post-dialog navigation.
      }
    });

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) => AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: config.themeMode,
      routerConfig: createAppRouter(refreshListenable: refreshListenable),
    );
  }
}