import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';

enum NodeIconKind {
  regular,
  boss,
  library,
  premium,
  event,
  daily,
  tournament,
  seasonal,
  completed,
  locked,
  unknown,
}

enum NodeIconVariant { filled, outlined, tonal, glyph }

class NodeIcon extends StatelessWidget {
  const NodeIcon({
    super.key,
    required this.kind,
    this.variant = NodeIconVariant.filled,
    this.size = PlaygroundSizes.nodeIconSize,
    this.color,
    this.isEnabled = true,
    this.semanticLabel,
  });

  final NodeIconKind kind;
  final NodeIconVariant variant;
  final double size;
  final Color? color;
  final bool isEnabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedColor = _resolveColor(theme);
    final effectiveColor = color ?? resolvedColor;
    final effectiveOpacity = isEnabled ? 1.0 : PlaygroundOpacity.disabled;

    final IconData icon = _resolveIcon();

    return Semantics(
      label: semanticLabel ?? kind.name,
      container: true,
      child: Opacity(
        opacity: effectiveOpacity,
        child: SizedBox(
          height: size,
          width: size,
          child: _buildVariant(icon, effectiveColor, theme),
        ),
      ),
    );
  }

  Widget _buildVariant(IconData icon, Color effectiveColor, ThemeData theme) {
    switch (variant) {
      case NodeIconVariant.filled:
        return Container(
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: size, color: effectiveColor),
        );
      case NodeIconVariant.outlined:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: effectiveColor, width: 2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: size, color: effectiveColor),
        );
      case NodeIconVariant.tonal:
        return Container(
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: size, color: AppColors.darkOnSurface),
        );
      case NodeIconVariant.glyph:
        return Center(
          child: Icon(icon, size: size, color: effectiveColor),
        );
    }
  }

  IconData _resolveIcon() {
    switch (kind) {
      case NodeIconKind.regular:
        return AppIcons.trophy;
      case NodeIconKind.boss:
        return AppIcons.trophy;
      case NodeIconKind.library:
        return AppIcons.bookmark;
      case NodeIconKind.premium:
        return AppIcons.trophy;
      case NodeIconKind.event:
        return AppIcons.notification;
      case NodeIconKind.daily:
        return AppIcons.streak;
      case NodeIconKind.tournament:
        return AppIcons.trophy;
      case NodeIconKind.seasonal:
        return AppIcons.success;
      case NodeIconKind.completed:
        return AppIcons.success;
      case NodeIconKind.locked:
        return AppIcons.locked;
      case NodeIconKind.unknown:
        return AppIcons.info;
    }
  }

  Color _resolveColor(ThemeData theme) {
    switch (kind) {
      case NodeIconKind.regular:
        return AppColors.primary;
      case NodeIconKind.boss:
        return AppColors.error;
      case NodeIconKind.library:
        return AppColors.secondary;
      case NodeIconKind.premium:
        return AppColors.accent;
      case NodeIconKind.event:
        return AppColors.primary;
      case NodeIconKind.daily:
        return AppColors.accent;
      case NodeIconKind.tournament:
        return theme.colorScheme.tertiary;
      case NodeIconKind.seasonal:
        return AppColors.info;
      case NodeIconKind.completed:
        return AppColors.success;
      case NodeIconKind.locked:
        return AppColors.lightMuted;
      case NodeIconKind.unknown:
        return AppColors.lightMuted;
    }
  }
}
