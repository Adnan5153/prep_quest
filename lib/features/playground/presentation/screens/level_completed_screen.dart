import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../../gamification/domain/entities/reward.dart';
import '../../../gamification/domain/entities/reward_event.dart';
import '../../../gamification/domain/enums/reward_enums.dart';
import '../../../gamification/presentation/providers/rewards_provider.dart';
import '../../../gamification/presentation/widgets/rewards_celebration_dialogs.dart';
import '../widgets/level_reward_dialog.dart';

/// Summary screen shown after a level / challenge / boss has been cleared.
class LevelCompletedScreen extends ConsumerStatefulWidget {
  const LevelCompletedScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<LevelCompletedScreen> createState() =>
      _LevelCompletedScreenState();
}

class _LevelCompletedScreenState extends ConsumerState<LevelCompletedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final LevelCompletedData data = LevelCompletedData(
        levelId: widget.nodeId,
        isFirstClear: true,
        scoreRatio: 1.0,
      );
      await ref
          .read(rewardsControllerProvider.notifier)
          .grantFromEvent(trigger: RewardTrigger.levelCompleted, data: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Level Complete'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: AppSpacing.xl),
              Icon(
                Icons.emoji_events,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'You cleared ${widget.nodeId}',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Rewards granted and next node unlocked.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Spacer(),
              FilledButton(
                onPressed: () => _openRewardDialog(context),
                child: const Text('View Rewards'),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.playground),
                child: const Text('Continue Exploring'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRewardDialog(BuildContext context) {
    final RewardsViewState state = ref.read(rewardsControllerProvider);
    final int xpEarned = state.lastOutcome?.grants
            .whereType<XpReward>()
            .fold<int>(0, (int s, XpReward r) => s + r.amount) ??
        25;
    final int coinsEarned = state.lastOutcome?.grants
            .whereType<CoinReward>()
            .fold<int>(0, (int s, CoinReward r) => s + r.amount) ??
        10;
    final String? badgeEarned = state.lastOutcome?.grants
        .whereType<BadgeReward>()
        .map((BadgeReward r) => r.title)
        .cast<String?>()
        .firstWhere((String? t) => t != null, orElse: () => null);
    LevelRewardDialog.show(
      context,
      visual: LevelRewardDialogVisual(
        levelNumber: _nodeIndex(widget.nodeId),
        xpEarned: xpEarned,
        coinsEarned: coinsEarned,
        badgeEarned: badgeEarned,
        nextLevelNumber: _nodeIndex(widget.nodeId) + 1,
      ),
      onPrimary: () async {
        if (state.lastOutcome != null) {
          if (state.lastOutcome!.celebration.showLevelUpDialog) {
            if (!context.mounted) return;
            await LevelUpCelebrationDialog.show(
              context,
              outcome: state.lastOutcome!,
            );
          }
          if (state.lastOutcome!.celebration.showBadgeUnlock) {
            if (!context.mounted) return;
            await BadgeUnlockCelebrationDialog.show(
              context,
              outcome: state.lastOutcome!,
            );
          }
        }
        if (!context.mounted) return;
        context.goNamed(AppRoutes.playground);
      },
      onSecondary: () => context.goNamed(AppRoutes.playground),
      primaryLabel: 'Continue',
      secondaryLabel: 'Replay',
    );
  }

  int _nodeIndex(String id) {
    const prefix = 'node-';
    if (!id.startsWith(prefix)) return 1;
    return int.tryParse(id.substring(prefix.length)) ?? 1;
  }
}