import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/reward_outcome.dart';
import '../constants/rewards_strings.dart';

/// Modal that celebrates a leveled-up state.
class LevelUpCelebrationDialog extends StatelessWidget {
  const LevelUpCelebrationDialog({
    super.key,
    required this.outcome,
  });

  final RewardOutcome outcome;

  static Future<void> show(
    BuildContext context, {
    required RewardOutcome outcome,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => LevelUpCelebrationDialog(outcome: outcome),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              AppIcons.crown,
              size: 64,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              RewardsStrings.levelUpDialogTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              RewardsStrings.levelUpDialogSubtitleTemplate.replaceAll(
                '%d',
                '${outcome.stateAfter.level.currentLevel}',
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(RewardsStrings.levelUpDialogContinue),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal that celebrates a freshly unlocked badge.
class BadgeUnlockCelebrationDialog extends StatelessWidget {
  const BadgeUnlockCelebrationDialog({
    super.key,
    required this.outcome,
  });

  final RewardOutcome outcome;

  static Future<void> show(
    BuildContext context, {
    required RewardOutcome outcome,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BadgeUnlockCelebrationDialog(outcome: outcome),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BadgeReward? badge = outcome.grants
        .whereType<BadgeReward>()
        .cast<BadgeReward?>()
        .firstWhere(
          (BadgeReward? b) => b != null,
          orElse: () => null,
        );
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              AppIcons.badgeStar,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              RewardsStrings.badgeUnlockTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            if (badge != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                badge.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                badge.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(RewardsStrings.badgeUnlockContinue),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal that announces a freshly opened chest.
class ChestOpenCelebrationDialog extends StatelessWidget {
  const ChestOpenCelebrationDialog({
    super.key,
    required this.outcome,
  });

  final RewardOutcome outcome;

  static Future<void> show(
    BuildContext context, {
    required RewardOutcome outcome,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ChestOpenCelebrationDialog(outcome: outcome),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int xpTotal = outcome.grants
        .whereType<XpReward>()
        .fold<int>(0, (int sum, XpReward r) => sum + r.amount);
    final int coinTotal = outcome.grants
        .whereType<CoinReward>()
        .fold<int>(0, (int sum, CoinReward r) => sum + r.amount);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              AppIcons.gem,
              size: 64,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              RewardsStrings.chestOpenTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            if (xpTotal > 0)
              Text(
                RewardsStrings.historyXpTemplate.replaceAll(
                  '%d',
                  '$xpTotal',
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            if (coinTotal > 0)
              Text(
                RewardsStrings.historyCoinTemplate.replaceAll(
                  '%d',
                  '$coinTotal',
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(RewardsStrings.chestOpenContinue),
            ),
          ],
        ),
      ),
    );
  }
}