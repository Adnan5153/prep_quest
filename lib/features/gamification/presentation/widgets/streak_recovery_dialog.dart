import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/enums/streak_enums.dart';
import '../constants/streak_strings.dart';

/// Modal bottom-sheet that lets the user pick a recovery method.
class StreakRecoveryDialog extends StatelessWidget {
  const StreakRecoveryDialog({super.key, required this.onConfirm});

  final void Function(RecoveryMethod method) onConfirm;

  static Future<RecoveryMethod?> show(
    BuildContext context, {
    required void Function(RecoveryMethod method) onConfirm,
  }) {
    return showModalBottomSheet<RecoveryMethod>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          StreakRecoveryDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              StreakStrings.recoveryTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              StreakStrings.recoverySubtitle,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _MethodTile(
              title: StreakStrings.recoveryCoinsTitle,
              subtitle: StreakStrings.recoveryCoinsSubtitle,
              icon: AppIcons.coinIcon,
              color: AppColors.warning,
              onTap: () {
                Navigator.of(context).pop(RecoveryMethod.coins);
                onConfirm(RecoveryMethod.coins);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _MethodTile(
              title: StreakStrings.recoveryPremiumTitle,
              subtitle: StreakStrings.recoveryPremiumSubtitle,
              icon: AppIcons.crown,
              color: AppColors.accent,
              onTap: () {
                Navigator.of(context).pop(RecoveryMethod.premium);
                onConfirm(RecoveryMethod.premium);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(StreakStrings.recoveryCancel),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: color.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: AppSizes.iconLg, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                AppIcons.chevronRight,
                size: AppSizes.iconMd,
                color: AppColors.lightMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}