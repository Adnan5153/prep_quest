import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/profile_strings.dart';

/// Single quick-action tile used by [ProfileQuickActions].
class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = color ?? theme.colorScheme.primary;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: tint.withValues(alpha: 0.20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: tint, size: AppSizes.iconLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Convenience labels for the standard quick-action set.
class ProfileActionLabels {
  const ProfileActionLabels._();

  static const Map<String, String> defaults = <String, String>{
    'resume': ProfileStrings.resumeAction,
    'mock_test': ProfileStrings.mockTestAction,
    'guidebook': ProfileStrings.guidebookAction,
    'leaderboard': ProfileStrings.leaderboardAction,
    'ai_tutor': ProfileStrings.aiTutorAction,
  };
}