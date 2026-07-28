import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/quiz_results_visual_mapper.dart';

/// Coin reward card.
class CoinRewardCard extends StatelessWidget {
  const CoinRewardCard({super.key, required this.visual});

  final CoinRewardVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: <Widget>[
          const Icon(Icons.savings_rounded, color: AppColors.warning, size: 32),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '+${visual.amount}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.warning,
            ),
          ),
          Text('coins', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
