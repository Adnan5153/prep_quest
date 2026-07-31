import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/level_curve.dart';
import '../../../../router.dart';
import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../constants/playground_constants.dart';
import '../widgets/level_card.dart';
import '../widgets/locked_level.dart';
import '../widgets/rewards/reward_popup.dart';

/// Full-screen lesson / level detail. Reached when the user taps an unlocked
/// regular or milestone node on the Playground map.
class LevelScreen extends ConsumerWidget {
  const LevelScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isBoss = nodeId.contains('boss');
    final AsyncValue<_LevelRewards> rewardsAsync =
        ref.watch(_levelRewardsProvider(nodeId));
    final _LevelRewards rewards =
        rewardsAsync.maybeWhen(data: (v) => v, orElse: _LevelRewards.empty);
    final int xpReward = rewards.xp;
    final int coinReward = rewards.coins;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level $nodeId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LevelCard(
                visual: LevelCardVisual(
                  title: 'Lesson $nodeId',
                  subtitle: 'Tap to begin the lesson',
                  difficulty: 'medium',
                  state: LevelCardState.unlocked,
                  reward: LevelCardReward(xp: xpReward, coins: coinReward),
                  progress: 0.0,
                  duration: 5,
                  energy: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _LockedSection(),
              const Spacer(),
              FilledButton.icon(
                icon: Icon(isBoss ? Icons.shield : Icons.play_arrow),
                label: Text(isBoss ? 'Open Boss Challenge' : 'Start Lesson'),
                onPressed: () => _onStart(context, xpReward, coinReward),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.playground),
                child: const Text('Back to map'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Theme: ${theme.brightness.name}',
                style: theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onStart(BuildContext context, int xpReward, int coinReward) {
    if (nodeId.contains('boss')) {
      context.goNamed(
        AppRoutes.bossChallenge,
        queryParameters: <String, String>{'nodeId': nodeId},
      );
      return;
    }
    RewardPopup.show(
      context,
      entries: <RewardEntry>[
        RewardEntry(
          kind: RewardEntryKind.xp,
          amount: xpReward,
          rarity: PlaygroundRarity.rare,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: coinReward,
          rarity: PlaygroundRarity.common,
        ),
      ],
      onPrimary: () => context.goNamed(
        AppRoutes.levelCompleted,
        queryParameters: <String, String>{'nodeId': nodeId},
      ),
    );
  }
}

/// Lightweight value object so [LevelScreen] can read both XP and
/// coin rewards from a single provider emission. Keeps the widget
/// tree flat and prevents two concurrent provider watches from
/// drifting during loading.
class _LevelRewards {
  const _LevelRewards({required this.xp, required this.coins});

  const _LevelRewards.empty()
      : xp = 0,
        coins = 0;

  final int xp;
  final int coins;
}

/// Resolves the XP / coin rewards advertised by the active category.
/// Falls back to `0` while the category stream is loading or the
/// category is unknown so the widget never has to invent a hardcoded
/// number.
final _levelRewardsProvider =
    FutureProvider.family<_LevelRewards, String>((ref, nodeId) async {
  final CategoryEntity? category =
      await ref.watch(categoryByIdProvider(nodeId).future);
  if (category == null) return const _LevelRewards.empty();
  return _LevelRewards(xp: category.xpReward, coins: category.coinReward);
});

class _LockedSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).profile;
    final int currentLevel = profile?.progression.level ?? 1;
    final int xpNeeded =
        LevelCurve.defaultCurve.xpRequiredForLevel(currentLevel + 1);
    final int xpShortBy = (xpNeeded -
            (profile?.progression.xpInLevel ?? 0))
        .clamp(0, xpNeeded);
    return LockedLevel(
      visual: LockedLevelVisual(
        levelNumber: currentLevel + 1,
        title: 'Upcoming',
        subtitle: 'Locked until prerequisite complete',
        requirements: <LockedLevelRequirementSpec>[
          LockedLevelRequirementSpec(
            kind: LockedLevelRequirement.level,
            label:
                'Reach Level ${currentLevel + 1} (~$xpShortBy more XP)',
          ),
        ],
      ),
    );
  }
}