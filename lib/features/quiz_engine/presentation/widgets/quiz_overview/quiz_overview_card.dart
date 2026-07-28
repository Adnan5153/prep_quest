import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../utils/quiz_visual_mapper.dart';
import 'quiz_overview_card_body.dart';
import 'quiz_overview_card_header.dart';

/// Composite card used by the Quiz Overview screen. Pulled apart so
/// each part is single-responsibility and reusable.
class QuizOverviewCard extends StatelessWidget {
  const QuizOverviewCard({
    super.key,
    required this.visual,
    required this.onTap,
    this.completionRatio = 0,
    this.isLocked = false,
  });

  final QuizCardVisual visual;
  final VoidCallback onTap;
  final double completionRatio;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: isLocked ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              QuizOverviewCardHeader(visual: visual, isLocked: isLocked),
              const SizedBox(height: AppSpacing.md),
              QuizOverviewCardBody(
                visual: visual,
                completionRatio: completionRatio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}