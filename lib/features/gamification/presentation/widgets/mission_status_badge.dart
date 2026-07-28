import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/enums/mission_enums.dart';

/// Compact status pill summarising a mission's lifecycle phase.
class MissionStatusBadge extends StatelessWidget {
  const MissionStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final MissionStatus status;
  final bool compact;

  ({Color fg, Color bg, IconData icon, String label}) _resolve(
    BuildContext context,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    switch (status) {
      case MissionStatus.locked:
        return (
          fg: muted,
          bg: muted.withValues(alpha: 0.18),
          icon: AppIcons.locked,
          label: MissionStrings.statusLocked,
        );
      case MissionStatus.available:
        return (
          fg: AppColors.info,
          bg: AppColors.info.withValues(alpha: 0.18),
          icon: AppIcons.missionOutline,
          label: MissionStrings.statusAvailable,
        );
      case MissionStatus.inProgress:
        return (
          fg: AppColors.accent,
          bg: AppColors.accent.withValues(alpha: 0.18),
          icon: AppIcons.sparkle,
          label: MissionStrings.statusInProgress,
        );
      case MissionStatus.completed:
        return (
          fg: AppColors.success,
          bg: AppColors.success.withValues(alpha: 0.18),
          icon: AppIcons.checkCircle,
          label: MissionStrings.statusCompleted,
        );
      case MissionStatus.claimed:
        return (
          fg: AppColors.secondary,
          bg: AppColors.secondary.withValues(alpha: 0.18),
          icon: AppIcons.success,
          label: MissionStrings.statusClaimed,
        );
      case MissionStatus.expired:
        return (
          fg: AppColors.error,
          bg: AppColors.error.withValues(alpha: 0.18),
          icon: AppIcons.warning,
          label: MissionStrings.statusExpired,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve(context);
    final EdgeInsetsGeometry padding = compact
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          );
    return Semantics(
      label: resolved.label,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: resolved.bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: resolved.fg.withValues(alpha: 0.45),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(resolved.icon, size: compact ? 12 : 14, color: resolved.fg),
            const SizedBox(width: AppSpacing.xs),
            Text(
              resolved.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: resolved.fg,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}