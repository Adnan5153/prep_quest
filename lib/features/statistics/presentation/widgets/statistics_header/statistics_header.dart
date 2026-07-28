import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../providers/statistics_provider.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../shared/statistics_state_views.dart';

class StatisticsHeader extends ConsumerWidget {
  const StatisticsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StatisticsState state = ref.watch(statisticsControllerProvider);
    final StatisticsVisual? visual = state.visual;
    final ThemeData theme = Theme.of(context);
    final String subtitle = visual == null
        ? StatisticsStrings.loading
        : 'You are on a ${visual.study.streakDays}-day streak. Keep it up!';

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          AppColors.primary,
          Color(0xFF1FA063),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StatisticsStrings.screenTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref
                .read(statisticsControllerProvider.notifier)
                .load(forceRefresh: true),
          ),
        ],
      ),
    );
  }
}

class StatisticsHeaderSkeleton extends StatelessWidget {
  const StatisticsHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassCardSkeleton(height: 96);
  }
}