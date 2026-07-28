import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/lesson_entity.dart';

class LessonCardFooter extends StatelessWidget {
  const LessonCardFooter({
    super.key,
    required this.lesson,
    required this.progress,
  });

  final LessonEntity lesson;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _MetaChip(
          icon: Icons.schedule,
          label: '${lesson.estimatedReadingMinutes} min',
        ),
        _MetaChip(
          icon: Icons.signal_cellular_alt,
          label: lesson.difficulty,
        ),
        _MetaChip(
          icon: Icons.bolt,
          label: '+${lesson.rewardXp} XP',
          color: theme.colorScheme.primary,
        ),
        if (lesson.isPremium)
          _MetaChip(
            icon: Icons.workspace_premium,
            label: 'Premium',
            color: theme.colorScheme.tertiary,
          ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.color});

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
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: effectiveColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}