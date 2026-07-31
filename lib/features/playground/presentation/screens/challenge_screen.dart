import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';
import '../constants/playground_constants.dart';
import '../widgets/challenge_tile.dart';
import '../widgets/rewards/reward_popup.dart';

/// Challenge screen reached from challenge-style nodes on the Playground map.
///
/// Rewards are sourced from the underlying [CategoryEntity]
/// (xpReward / coinReward) so the displayed amounts always match the
/// data sourced from the categories collection — no hardcoded values.
class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<_ChallengeRewards> rewardsAsync =
        ref.watch(_challengeRewardsProvider(nodeId));
    final _ChallengeRewards rewards = rewardsAsync.maybeWhen(
      data: (v) => v,
      orElse: _ChallengeRewards.empty,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge $nodeId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            Text(
              'Daily Challenges',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            ChallengeTile(
              visual: ChallengeTileVisual(
                title: 'Grammar Quiz',
                subtitle: '5 questions, 2 minutes',
                kind: PlaygroundChallengeKind.quiz,
                difficulty: 'easy',
                xpReward: rewards.xp,
                coinReward: rewards.coins,
              ),
              onTap: () => _claimReward(context, rewards),
            ),
            const SizedBox(height: AppSpacing.md),
            ChallengeTile(
              visual: ChallengeTileVisual(
                title: 'Reading Sprint',
                subtitle: 'Read 1 short passage',
                kind: PlaygroundChallengeKind.reading,
                difficulty: 'medium',
                xpReward: rewards.xp,
                coinReward: rewards.coins,
              ),
              onTap: () => _claimReward(context, rewards),
            ),
            const SizedBox(height: AppSpacing.md),
            ChallengeTile(
              visual: ChallengeTileVisual(
                title: 'Mini Boss',
                subtitle: 'Defeat 3 tricky items',
                kind: PlaygroundChallengeKind.miniBoss,
                difficulty: 'hard',
                xpReward: rewards.xp,
                coinReward: rewards.coins,
              ),
              onTap: () => _claimReward(context, rewards),
            ),
          ],
        ),
      ),
    );
  }

  void _claimReward(BuildContext context, _ChallengeRewards rewards) {
    RewardPopup.show(
      context,
      entries: <RewardEntry>[
        RewardEntry(
          kind: RewardEntryKind.xp,
          amount: rewards.xp,
          rarity: PlaygroundRarity.epic,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: rewards.coins,
          rarity: PlaygroundRarity.rare,
        ),
      ],
      onPrimary: () => context.goNamed(
        AppRoutes.levelCompleted,
        queryParameters: <String, String>{'nodeId': nodeId},
      ),
    );
  }
}

class _ChallengeRewards {
  const _ChallengeRewards({required this.xp, required this.coins});

  const _ChallengeRewards.empty()
      : xp = 0,
        coins = 0;

  final int xp;
  final int coins;
}

final _challengeRewardsProvider =
    FutureProvider.family<_ChallengeRewards, String>((ref, nodeId) async {
  final CategoryEntity? category =
      await ref.watch(categoryByIdProvider(nodeId).future);
  if (category == null) return const _ChallengeRewards.empty();
  return _ChallengeRewards(xp: category.xpReward, coins: category.coinReward);
});