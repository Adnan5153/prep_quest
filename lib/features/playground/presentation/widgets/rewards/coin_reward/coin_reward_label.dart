import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_strings.dart';

class CoinRewardLabel extends StatelessWidget {
  const CoinRewardLabel({
    super.key,
    required this.amount,
    required this.isDark,
  });

  final int amount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final onSurface = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          PlaygroundStrings.coinLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: muted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${PlaygroundStrings.rewardCoinLabelTemplate}$amount',
          style: theme.textTheme.titleMedium?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
