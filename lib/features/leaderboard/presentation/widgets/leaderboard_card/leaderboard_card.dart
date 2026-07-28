import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/leaderboard_category_entity.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Compact category preview card for the leaderboard hub.
class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({
    super.key,
    required this.category,
    this.onTap,
  });

  final LeaderboardCategoryEntity category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  category.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${category.totalParticipants} ${strings.LeaderboardStrings.detailParticipants}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            category.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...category.entries
              .take(3)
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 28,
                          child: Text(
                            '#${entry.rank}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          entry.username,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          '${entry.xp} XP',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )),
          if (category.currentUserEntry != null) ...<Widget>[
            const Divider(),
            Row(
              children: <Widget>[
                Icon(Icons.person_rounded,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(strings.LeaderboardStrings.currentUserHeadline),
                const Spacer(),
                Text(
                  '#${category.currentUserEntry!.rank}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Backwards-compatible alias for consumers that imported the old
/// feature-level card name.
typedef LeaderboardCategoryCard = LeaderboardCard;
