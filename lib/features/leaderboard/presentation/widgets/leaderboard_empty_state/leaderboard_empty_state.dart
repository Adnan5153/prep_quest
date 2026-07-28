import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Empty state displayed when a scope has no ranking entries.
class LeaderboardEmptyState extends StatelessWidget {
  const LeaderboardEmptyState({
    super.key,
    this.onAction,
  });

  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              AppIcons.trophy,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.LeaderboardStrings.emptyTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              strings.LeaderboardStrings.emptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: strings.LeaderboardStrings.retry,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}