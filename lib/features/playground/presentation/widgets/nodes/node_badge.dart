import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

enum NodeBadgeKind {
  boss,
  library,
  premium,
  event,
  daily,
  tournament,
  seasonal,
  xp,
  completed,
  newBadge,
}

class NodeBadge extends StatelessWidget {
  const NodeBadge({
    super.key,
    required this.kind,
    this.size = PlaygroundSizes.nodeBadgeSize,
    this.offset = PlaygroundSizes.nodeBadgeOffset,
    this.semanticLabel,
  });

  final NodeBadgeKind kind;
  final double size;
  final double offset;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _resolveConfig(kind, theme);

    return Positioned(
      top: offset,
      right: offset,
      child: Semantics(
        label: semanticLabel ?? config.semanticLabel,
        container: true,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: config.background,
            gradient: config.gradient,
            shape: BoxShape.circle,
            border: Border.all(
              color: config.borderColor,
              width: WidgetConstants.outlineThickness,
            ),
            boxShadow: config.showShadow
                ? const [
                    BoxShadow(
                      color: AppColors.darkBackground,
                      blurRadius: PlaygroundSizes.nodeShadowBlur,
                      offset: PlaygroundSizes.nodeShadowOffset,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2),
          child: Icon(config.icon, size: size * 0.6, color: config.foreground),
        ),
      ),
    );
  }

  _BadgeConfig _resolveConfig(NodeBadgeKind kind, ThemeData theme) {
    switch (kind) {
      case NodeBadgeKind.boss:
        return _BadgeConfig(
          icon: AppIcons.trophy,
          background: AppColors.error,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeBoss,
        );
      case NodeBadgeKind.library:
        return _BadgeConfig(
          icon: AppIcons.bookmark,
          background: AppColors.secondary,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeLibrary,
        );
      case NodeBadgeKind.premium:
        return _BadgeConfig(
          icon: AppIcons.trophy,
          background: AppColors.accent,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgePremium,
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          showShadow: true,
        );
      case NodeBadgeKind.event:
        return _BadgeConfig(
          icon: AppIcons.notification,
          background: AppColors.primary,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeEvent,
        );
      case NodeBadgeKind.daily:
        return _BadgeConfig(
          icon: AppIcons.streak,
          background: AppColors.accent,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeDaily,
        );
      case NodeBadgeKind.tournament:
        return _BadgeConfig(
          icon: AppIcons.trophy,
          background: theme.colorScheme.tertiary,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeTournament,
        );
      case NodeBadgeKind.seasonal:
        return _BadgeConfig(
          icon: AppIcons.success,
          background: AppColors.info,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeSeasonal,
        );
      case NodeBadgeKind.xp:
        return _BadgeConfig(
          icon: AppIcons.xp,
          background: AppColors.warning,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeXp,
        );
      case NodeBadgeKind.completed:
        return _BadgeConfig(
          icon: AppIcons.success,
          background: AppColors.success,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeCompleted,
        );
      case NodeBadgeKind.newBadge:
        return _BadgeConfig(
          icon: AppIcons.notification,
          background: AppColors.primary,
          foreground: AppColors.darkOnSurface,
          borderColor: AppColors.darkOnSurface,
          semanticLabel: PlaygroundStrings.nodeBadgeNew,
        );
    }
  }
}

class _BadgeConfig {
  const _BadgeConfig({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.borderColor,
    required this.semanticLabel,
    this.gradient,
    this.showShadow = true,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final Color borderColor;
  final String semanticLabel;
  final Gradient? gradient;
  final bool showShadow;
}
