import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_radius.dart';
import '../../../../constants/app_sizes.dart';
import '../../ai_constants.dart';
import '../ai_history_models.dart';
import '../ai_history_utils.dart';

/// Leading avatar displayed inside an [AiHistoryCard].
class AiHistoryAvatar extends StatelessWidget {
  const AiHistoryAvatar({super.key, required this.entry, required this.isDark});

  final AiHistoryItem entry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color accent = AiHistoryUtils.accentFor(entry.type);
    final Color background = accent.withValues(alpha: isDark ? 0.22 : 0.16);
    final IconData icon =
        entry.leadingIcon ?? AiHistoryUtils.defaultIconFor(entry.type);
    final String initials =
        (entry.avatarLabel ?? AiHistoryUtils.initials(entry.title))
            .toUpperCase()
            .characters
            .take(2)
            .toString();

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: AiConstants.compactAvatarSize + 8,
          height: AiConstants.compactAvatarSize + 8,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.40 : 0.30),
              width: AppSizes.borderThin,
            ),
          ),
          alignment: Alignment.center,
          child: entry.avatarLabel != null && entry.leadingIcon == null
              ? Text(
                  initials,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : Icon(icon, size: AppSizes.iconMd, color: accent),
        ),
        if (entry.isUnread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBackground,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
