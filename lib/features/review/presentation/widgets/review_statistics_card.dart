import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/date_extension.dart';
import '../constants/review_strings.dart';
import '../providers/review_provider.dart';

/// Aggregate stats card shown on the Review screen header. Renders a
/// four-tile grid summarising accuracy, total attempts, bookmarks, and
/// total time spent.
class ReviewStatisticsCard extends StatelessWidget {
  const ReviewStatisticsCard({super.key, required this.statistics});

  final ReviewStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.analytics_outlined,
                  size: 22, color: theme.colorScheme.onPrimary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Your review insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.4,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            children: <Widget>[
              _StatTile(
                label: ReviewStrings.statsAccuracy,
                value: '${(statistics.accuracy * 100).round()}%',
                color: theme.colorScheme.onPrimary,
                background: Colors.white.withValues(alpha: 0.16),
              ),
              _StatTile(
                label: ReviewStrings.statsTotal,
                value: '${statistics.totalAttempts}',
                color: theme.colorScheme.onPrimary,
                background: Colors.white.withValues(alpha: 0.16),
              ),
              _StatTile(
                label: ReviewStrings.statsBookmarks,
                value: '${statistics.bookmarkCount}',
                color: theme.colorScheme.onPrimary,
                background: Colors.white.withValues(alpha: 0.16),
              ),
              _StatTile(
                label: ReviewStrings.statsTimeSpent,
                value: statistics.timeSpentSeconds.asDuration(),
                color: theme.colorScheme.onPrimary,
                background: Colors.white.withValues(alpha: 0.16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}