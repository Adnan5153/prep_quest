import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';
import '../constants/playground_constants.dart';
import '../widgets/boss_gate.dart';
import '../widgets/rewards/reward_popup.dart';

/// Boss challenge screen opened by tapping an unlocked boss gate.
///
/// Rewards are sourced from the underlying [CategoryEntity]
/// (xpReward / coinReward) so the displayed amounts always match the
/// data sourced from the categories collection — no hardcoded values.
class BossChallengeScreen extends ConsumerWidget {
  const BossChallengeScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<_BossRewards> rewardsAsync =
        ref.watch(_bossRewardsProvider(nodeId));
    final _BossRewards rewards = rewardsAsync.maybeWhen(
      data: (v) => v,
      orElse: _BossRewards.empty,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Boss: $nodeId'),
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
              Center(
                child: BossGate(
                  visual: BossGateVisual(
                    title: 'BCS Boss',
                    requiredLevel: 5,
                    subtitle: 'Final challenge',
                    rarity: BossGateRarity.legendary,
                  ),
                  state: BossGateState.open,
                  onTap: () => _claimReward(context, rewards),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Defeat the boss to claim the legendary reward.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.emoji_events),
                label: const Text('Claim Boss Reward'),
                onPressed: () => _claimReward(context, rewards),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.playground),
                child: const Text('Return to map'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _claimReward(BuildContext context, _BossRewards rewards) {
    RewardPopup.show(
      context,
      entries: <RewardEntry>[
        RewardEntry(
          kind: RewardEntryKind.xp,
          amount: rewards.xp,
          rarity: PlaygroundRarity.legendary,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: rewards.coins,
          rarity: PlaygroundRarity.epic,
        ),
        RewardEntry(
          kind: RewardEntryKind.badge,
          amount: 1,
          rarity: PlaygroundRarity.legendary,
        ),
      ],
      onPrimary: () => context.goNamed(
        AppRoutes.levelCompleted,
        queryParameters: <String, String>{'nodeId': nodeId},
      ),
    );
  }
}

/// Lightweight value object so [BossChallengeScreen] can read both XP and
/// coin rewards from a single provider emission. Keeps the widget tree
/// flat and prevents two concurrent provider watches from drifting
/// during loading.
class _BossRewards {
  const _BossRewards({required this.xp, required this.coins});

  const _BossRewards.empty()
      : xp = 0,
        coins = 0;

  final int xp;
  final int coins;
}

/// Resolves the XP / coin rewards advertised by the active category.
/// Falls back to `0` while the category stream is loading or the
/// category is unknown so the widget never has to invent a hardcoded
/// number.
final _bossRewardsProvider =
    FutureProvider.family<_BossRewards, String>((ref, nodeId) async {
  final CategoryEntity? category =
      await ref.watch(categoryByIdProvider(nodeId).future);
  if (category == null) return const _BossRewards.empty();
  return _BossRewards(xp: category.xpReward, coins: category.coinReward);
});