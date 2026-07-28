import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/playground_constants.dart';
import '../widgets/boss_gate.dart';
import '../widgets/rewards/reward_popup.dart';

/// Boss challenge screen opened by tapping an unlocked boss gate.
class BossChallengeScreen extends StatelessWidget {
  const BossChallengeScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                  onTap: () => _claimReward(context),
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
                onPressed: () => _claimReward(context),
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

  void _claimReward(BuildContext context) {
    RewardPopup.show(
      context,
      entries: <RewardEntry>[
        RewardEntry(
          kind: RewardEntryKind.xp,
          amount: 100,
          rarity: PlaygroundRarity.legendary,
        ),
        RewardEntry(
          kind: RewardEntryKind.coin,
          amount: 50,
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