import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../utils/quiz_visual_mapper.dart';

class QuizOverviewCardBody extends StatelessWidget {
  const QuizOverviewCardBody({
    super.key,
    required this.visual,
    required this.completionRatio,
  });

  final QuizCardVisual visual;
  final double completionRatio;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            value: completionRatio.clamp(0, 1),
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${(completionRatio * 100).round()}% mastered',
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: <Widget>[
            _MetaChip(
              icon: Icons.format_list_numbered,
              label: '${visual.questionCount} questions',
            ),
            _MetaChip(
              icon: Icons.schedule,
              label: visual.durationLabel,
            ),
            _MetaChip(
              icon: Icons.signal_cellular_alt,
              label: visual.difficultyId,
            ),
            _MetaChip(
              icon: Icons.bolt,
              label: '+${visual.rewardXp} XP',
              color: theme.colorScheme.primary,
            ),
            if (visual.rewardCoins > 0)
              _MetaChip(
                icon: Icons.savings_outlined,
                label: '+${visual.rewardCoins}',
              ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: effectiveColor),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}