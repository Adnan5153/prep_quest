import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/playground_constants.dart';
import '../widgets/level_card.dart';
import '../widgets/locked_level.dart';
import '../widgets/rewards/reward_popup.dart';

/// Full-screen lesson / level detail. Reached when the user taps an unlocked
/// regular or milestone node on the Playground map.
class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isBoss = nodeId.contains('boss');

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
                  reward: const LevelCardReward(xp: 25, coins: 10),
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
                onPressed: () => _onStart(context),
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

  void _onStart(BuildContext context) {
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
          amount: 25,
          rarity: PlaygroundRarity.rare,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: 10,
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

class _LockedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LockedLevel(
      visual: LockedLevelVisual(
        levelNumber: 99,
        title: 'Upcoming',
        subtitle: 'Locked until prerequisite complete',
        requirements: const <LockedLevelRequirementSpec>[
          LockedLevelRequirementSpec(
            kind: LockedLevelRequirement.level,
            label: 'Reach Level 4',
          ),
        ],
      ),
    );
  }
}