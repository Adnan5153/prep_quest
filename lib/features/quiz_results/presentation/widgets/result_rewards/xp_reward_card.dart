import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/quiz_results_visual_mapper.dart';

/// XP reward card.
class XPRewardCard extends StatelessWidget {
  const XPRewardCard({super.key, required this.visual});

  final XPRewardVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: <Widget>[
          const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 32),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '+${visual.amount}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
            ),
          ),
          Text('XP', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
