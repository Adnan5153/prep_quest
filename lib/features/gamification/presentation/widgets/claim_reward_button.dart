import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';

/// Single button used to claim a completed mission's reward.
class ClaimRewardButton extends StatelessWidget {
  const ClaimRewardButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color fg = enabled ? scheme.onPrimary : scheme.onSurfaceVariant;
    final Color bg = enabled ? scheme.primary : scheme.surfaceContainerHighest;
    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled
          ? MissionStrings.claimButton
          : MissionStrings.claimedLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  enabled ? AppIcons.sparkle : AppIcons.success,
                  size: 18,
                  color: fg,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  enabled
                      ? MissionStrings.claimButton
                      : MissionStrings.claimedLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}