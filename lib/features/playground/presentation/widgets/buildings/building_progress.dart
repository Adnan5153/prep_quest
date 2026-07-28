import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../painters/node_progress_arc_painter.dart';

enum BuildingProgressKind { percent, level, levelUp }

class BuildingProgress extends StatelessWidget {
  const BuildingProgress({
    super.key,
    required this.progress,
    required this.kind,
    this.size = PlaygroundSizes.buildingProgressSize,
    this.level,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.semanticLabel,
  });

  final double progress;
  final BuildingProgressKind kind;
  final double size;
  final int? level;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = backgroundColor ?? AppColors.buildingGold;
    final fg = foregroundColor ?? AppColors.darkOnSurface;
    final outline =
        borderColor ?? AppColors.darkOnSurface.withValues(alpha: 0.85);

    final Widget visual = switch (kind) {
      BuildingProgressKind.percent => _buildPercent(
        context: context,
        bg: bg,
        fg: fg,
        outline: outline,
        isDark: isDark,
      ),
      BuildingProgressKind.level => _buildLevel(
        context: context,
        bg: bg,
        fg: fg,
        outline: outline,
      ),
      BuildingProgressKind.levelUp => _buildLevelUp(
        context: context,
        bg: bg,
        fg: fg,
        outline: outline,
        isDark: isDark,
      ),
    };

    return Semantics(
      label: semanticLabel ?? _resolveSemanticLabel(),
      container: true,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: outline,
            width: WidgetConstants.focusedBorderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.darkBackground,
              blurRadius: PlaygroundSizes.buildingShadowBlur,
              offset: PlaygroundSizes.buildingShadowOffset,
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: visual,
      ),
    );
  }

  Widget _buildPercent({
    required BuildContext context,
    required Color bg,
    required Color fg,
    required Color outline,
    required bool isDark,
  }) {
    final clamped = progress.clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: NodeProgressArcPainter(
              progress: clamped,
              color: fg,
              trackColor: fg.withValues(alpha: isDark ? 0.18 : 0.30),
              strokeWidth: PlaygroundSizes.nodeRingStrokeWidth,
            ),
          ),
        ),
        Text(
          '${(clamped * 100).round()}%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildLevel({
    required BuildContext context,
    required Color bg,
    required Color fg,
    required Color outline,
  }) {
    final levelText = level != null ? '$level' : '1';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.trophy, size: size * 0.32, color: fg),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          levelText,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: fg,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelUp({
    required BuildContext context,
    required Color bg,
    required Color fg,
    required Color outline,
    required bool isDark,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.windowGlow.withValues(alpha: 0.85),
                  const Color(0x00FFD580),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.xp, size: size * 0.34, color: fg),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              PlaygroundStrings.buildingLevelUpLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _resolveSemanticLabel() {
    switch (kind) {
      case BuildingProgressKind.percent:
        return '${(progress * 100).round()} percent complete';
      case BuildingProgressKind.level:
        return 'Level ${level ?? 1}';
      case BuildingProgressKind.levelUp:
        return PlaygroundStrings.buildingLevelUpLabel;
    }
  }
}

class BuildingProgressChip extends StatelessWidget {
  const BuildingProgressChip({
    super.key,
    required this.progress,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.accentColor,
    this.isCompact = false,
  });

  final double progress;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? accentColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final clamped = progress.clamp(0.0, 1.0);

    final bg =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final fg =
        foregroundColor ??
        (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface);
    final accent = accentColor ?? AppColors.buildingGold;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.sm : AppSpacing.md,
        vertical: isCompact ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: accent.withValues(alpha: 0.45),
          width: WidgetConstants.outlineThickness,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkBackground,
            blurRadius: PlaygroundSizes.buildingShadowBlur,
            offset: PlaygroundSizes.buildingShadowOffset,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.xp,
            size: isCompact ? AppSizes.iconXs : AppSizes.iconSm,
            color: accent,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label ?? '${(clamped * 100).round()}%',
            style:
                (isCompact
                        ? theme.textTheme.labelSmall
                        : theme.textTheme.labelMedium)
                    ?.copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
