import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../constants/statistics_strings.dart';

class StatisticsLoadingView extends StatelessWidget {
  const StatisticsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(
            StatisticsStrings.loading,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class StatisticsErrorView extends StatelessWidget {
  const StatisticsErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          if (onRetry != null)
            PrimaryButton(
              text: StatisticsStrings.retryAction,
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}

class StatisticsEmptyView extends StatelessWidget {
  const StatisticsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: <Widget>[
          const Icon(Icons.bar_chart_outlined, size: 64),
          const SizedBox(height: AppSpacing.md),
          Text(
            StatisticsStrings.emptyTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              StatisticsStrings.emptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class GlassCardSkeleton extends StatelessWidget {
  const GlassCardSkeleton({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      height: height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}