import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';

enum LevelProgressStageStatus { done, current, upcoming }

class LevelProgressStageDot extends StatelessWidget {
  const LevelProgressStageDot({
    super.key,
    required this.size,
    required this.status,
    required this.isPremium,
    required this.isDark,
  });

  final double size;
  final LevelProgressStageStatus status;
  final bool isPremium;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final visuals = _resolveVisuals();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: visuals.fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: visuals.border,
          width: PlaygroundSizes.cardBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: visuals.child,
    );
  }

  _StageDotVisuals _resolveVisuals() {
    switch (status) {
      case LevelProgressStageStatus.done:
        return _StageDotVisuals(
          fill: PlaygroundColors.completed,
          border: PlaygroundColors.completed,
          child: Icon(
            AppIcons.checkCircle,
            size: size * 0.7,
            color: AppColors.darkOnSurface,
          ),
        );
      case LevelProgressStageStatus.current:
        final active = isPremium
            ? PlaygroundColors.premiumChrome
            : PlaygroundColors.xp;
        return _StageDotVisuals(
          fill: active,
          border: active,
          child: Container(
            width: size * 0.40,
            height: size * 0.40,
            decoration: const BoxDecoration(
              color: AppColors.darkOnSurface,
              shape: BoxShape.circle,
            ),
          ),
        );
      case LevelProgressStageStatus.upcoming:
        final fill = isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06);
        final border = isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.10);
        return _StageDotVisuals(fill: fill, border: border, child: null);
    }
  }
}

class _StageDotVisuals {
  const _StageDotVisuals({
    required this.fill,
    required this.border,
    required this.child,
  });

  final Color fill;
  final Color border;
  final Widget? child;
}
