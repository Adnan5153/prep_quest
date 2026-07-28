import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/entities/mission_reward_entity.dart';

/// Modal that announces a freshly claimed mission reward.
///
/// Uses the catalog-promise [MissionRewardEntity] (XP / coins / energy
/// / badge / chest labels) — no `RewardOutcome` is required because
/// the controller already dispatched the actual grant through the
/// rewards engine and that engine's celebration dialogs handle the
/// post-grant animation.
class MissionCompletedDialog extends StatelessWidget {
  const MissionCompletedDialog({
    super.key,
    required this.reward,
    this.missionTitle,
  });

  final MissionRewardEntity reward;
  final String? missionTitle;

  static Future<void> show(
    BuildContext context, {
    required MissionRewardEntity reward,
    String? missionTitle,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => MissionCompletedDialog(
        reward: reward,
        missionTitle: missionTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(AppIcons.sparkle, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(
              MissionStrings.completedDialogTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            if (missionTitle != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                missionTitle!,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(label: 'XP', value: '+${reward.xp}'),
            if (reward.coins > 0)
              _SummaryRow(label: 'Coins', value: '+${reward.coins}'),
            if (reward.energy > 0)
              _SummaryRow(label: 'Energy', value: '+${reward.energy}'),
            if (reward.hasBadge)
              _SummaryRow(
                label: MissionStrings.rewardBadgeLabel,
                value: reward.badgeId!,
              ),
            if (reward.hasChest)
              _SummaryRow(
                label: MissionStrings.rewardChestLabel,
                value: reward.chestId!,
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(MissionStrings.completedDialogContinue),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}