import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';

class LevelProgressBadge extends StatelessWidget {
  const LevelProgressBadge({
    super.key,
    required this.level,
    required this.isDark,
    required this.isPremium,
    required this.isCompleted,
    required this.scale,
  });

  final int level;
  final bool isDark;
  final bool isPremium;
  final bool isCompleted;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = PlaygroundSizes.cardLargeIconSize * scale;
    final fill = _fill();
    final fg = _foreground();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: fg.withValues(alpha: 0.30),
          width: PlaygroundSizes.cardBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$level',
        style: theme.textTheme.titleMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Color _fill() {
    if (isPremium) return Colors.white.withValues(alpha: 0.18);
    if (isCompleted) return PlaygroundColors.completed.withValues(alpha: 0.18);
    if (isDark) return Colors.white.withValues(alpha: 0.08);
    return Colors.black.withValues(alpha: 0.06);
  }

  Color _foreground() {
    if (isPremium) return AppColors.darkOnSurface;
    if (isCompleted) return PlaygroundColors.completed;
    if (isDark) return AppColors.darkOnSurface;
    return AppColors.lightOnSurface;
  }
}
