import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../domain/entities/user_profile.dart';
import '../../utils/profile_visual_mapper.dart';
import '../../constants/profile_strings.dart';

/// Two-tab grid: Achievements + Badges.
///
/// Earned badges glow; locked badges render muted with a progress arc.
class ProfileBadgeGrid extends StatelessWidget {
  const ProfileBadgeGrid({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int crossAxisCount = ResponsiveBuilder.value<int>(
      context,
      mobile: 3,
      tablet: 4,
      desktop: 6,
    );

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: const <Widget>[
                Tab(text: ProfileStrings.badgesSectionTitle),
                Tab(text: ProfileStrings.achievementsSectionTitle),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: ResponsiveBuilder.value<double>(
                context,
                mobile: 220,
                tablet: 260,
                desktop: 300,
              ),
              child: TabBarView(
                children: <Widget>[
                  _BadgeList(
                    items: profile.badges
                        .map(
                          (BadgeEntity b) => _BadgeItemData(
                            id: b.id,
                            name: b.name,
                            description: b.description,
                            icon: ProfileVisualMapper.iconFor(b.iconName),
                            earned: b.isEarned,
                            progress: b.progress,
                          ),
                        )
                        .toList(growable: false),
                    crossAxisCount: crossAxisCount,
                  ),
                  _AchievementsList(
                    items: profile.achievements,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeItemData {
  const _BadgeItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.earned,
    required this.progress,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final bool earned;
  final double progress;
}

class _BadgeList extends StatelessWidget {
  const _BadgeList({required this.items, required this.crossAxisCount});

  final List<_BadgeItemData> items;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          ProfileStrings.noBadges,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _BadgeTile(item: items[index]);
      },
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.item});

  final _BadgeItemData item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint =
        item.earned ? AppColors.accent : theme.colorScheme.outlineVariant;
    return Semantics(
      label:
          '${item.name}. ${item.earned ? ProfileStrings.earnedLabel : ProfileStrings.lockedLabel}.',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: tint.withValues(alpha: item.earned ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: tint.withValues(alpha: item.earned ? 0.6 : 0.4),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: AppSizes.iconLg,
                  height: AppSizes.iconLg,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tint.withValues(alpha: 0.4),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: AppSizes.iconMd,
                    color: item.earned ? AppColors.accent : tint,
                  ),
                ),
                if (!item.earned)
                  SizedBox(
                    width: AppSizes.iconLg + 6,
                    height: AppSizes.iconLg + 6,
                    child: CircularProgressIndicator(
                      value: item.progress.clamp(0.0, 1.0),
                      strokeWidth: 2,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(tint),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.name,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.description,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementsList extends StatelessWidget {
  const _AchievementsList({required this.items});

  final List<AchievementEntity> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          ProfileStrings.noAchievements,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final AchievementEntity achievement = items[index];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                ProfileVisualMapper.iconFor(achievement.iconName),
                color: AppColors.accent,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      achievement.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      achievement.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (achievement.xpReward > 0)
                Text(
                  '+${achievement.xpReward} ${ProfileStrings.xpLabel}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}