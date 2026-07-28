import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../utils/quiz_visual_mapper.dart';

class QuizOverviewCardHeader extends StatelessWidget {
  const QuizOverviewCardHeader({
    super.key,
    required this.visual,
    required this.isLocked,
  });

  final QuizCardVisual visual;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            _iconFor(visual.kindId),
            color: theme.colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                visual.subject,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                visual.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (visual.isPremium)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'Premium',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (isLocked)
          const Padding(
            padding: EdgeInsets.only(left: AppSpacing.xs),
            child: Icon(Icons.lock_outline),
          ),
      ],
    );
  }

  IconData _iconFor(String kindId) {
    switch (kindId) {
      case 'lessonPractice':
        return Icons.menu_book_outlined;
      case 'dailyChallenge':
        return Icons.calendar_today_outlined;
      case 'mockTest':
        return Icons.assignment_outlined;
      case 'bossGate':
        return Icons.shield_outlined;
      default:
        return Icons.quiz_outlined;
    }
  }
}