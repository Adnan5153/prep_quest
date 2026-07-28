import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../constants/rewards_strings.dart';
import '../providers/rewards_provider.dart';
import '../widgets/reward_history_tile.dart';

/// Paginated list of reward history entries.
class RewardHistoryScreen extends ConsumerStatefulWidget {
  const RewardHistoryScreen({super.key});

  @override
  ConsumerState<RewardHistoryScreen> createState() =>
      _RewardHistoryScreenState();
}

class _RewardHistoryScreenState extends ConsumerState<RewardHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(rewardsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RewardsViewState state = ref.watch(rewardsControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RewardsStrings.historyTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.history.isEmpty
                ? const _EmptyView()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveBuilder.value<double>(
                            context,
                            mobile: double.infinity,
                            tablet: AppSizes.tabletMaxWidth.toDouble(),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            for (final dynamic entry in state.history)
                              RewardHistoryTile(
                                entry: entry,
                                isDark: isDark,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(AppIcons.sparkle, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(
              RewardsStrings.historyEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}