import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/playground_constants.dart';
import '../widgets/challenge_tile.dart';
import '../widgets/rewards/reward_popup.dart';

/// Challenge screen reached from challenge-style nodes on the Playground map.
class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                xpReward: 15,
                coinReward: 5,
              ),
              onTap: () => _claimReward(context),
            ),
            const SizedBox(height: AppSpacing.md),
            ChallengeTile(
              visual: ChallengeTileVisual(
                title: 'Reading Sprint',
                subtitle: 'Read 1 short passage',
                kind: PlaygroundChallengeKind.reading,
                difficulty: 'medium',
                xpReward: 25,
                coinReward: 10,
              ),
              onTap: () => _claimReward(context),
            ),
            const SizedBox(height: AppSpacing.md),
            ChallengeTile(
              visual: ChallengeTileVisual(
                title: 'Mini Boss',
                subtitle: 'Defeat 3 tricky items',
                kind: PlaygroundChallengeKind.miniBoss,
                difficulty: 'hard',
                xpReward: 50,
                coinReward: 20,
              ),
              onTap: () => _claimReward(context),
            ),
          ],
        ),
      ),
    );
  }

  void _claimReward(BuildContext context) {
    RewardPopup.show(
      context,
      entries: <RewardEntry>[
        RewardEntry(
          kind: RewardEntryKind.xp,
          amount: 30,
          rarity: PlaygroundRarity.epic,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: 15,
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