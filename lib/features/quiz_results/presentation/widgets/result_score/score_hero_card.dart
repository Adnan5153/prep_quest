import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/quiz_results_visual_mapper.dart';

/// Big celebratory card that crowns the Quiz Results screen.
class ScoreHeroCard extends StatelessWidget {
  const ScoreHeroCard({super.key, required this.visual});

  final QuizResultsVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = visual.passed ? AppColors.success : AppColors.warning;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: <Color>[color, color.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${visual.scorePercent}%',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            visual.passed ? 'You passed!' : 'Almost there',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(5, (i) {
              final filled = i < visual.stars.stars.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: AppColors.accent,
                  size: AppSizes.iconLg,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
