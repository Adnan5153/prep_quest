import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../constants/leaderboard_strings.dart' as strings;
import '../providers/leaderboard_provider.dart';
import '../widgets/leaderboard_card/leaderboard_card.dart';
import '../widgets/leaderboard_empty_state/leaderboard_empty_state.dart';
import '../widgets/leaderboard_error_state/leaderboard_error_state.dart';
import '../widgets/leaderboard_loading_state/leaderboard_loading_state.dart';

/// Hub screen that lists every scope as a card and routes into
/// the per-scope detail screen.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(leaderboardControllerProvider.notifier).loadAll();
    });
  }

  Future<void> _refresh() async {
    await ref.read(leaderboardControllerProvider.notifier).loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final LeaderboardViewState state =
        ref.watch(leaderboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.LeaderboardStrings.hubTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(child: _Body(state: state, onRefresh: _refresh)),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state, required this.onRefresh});

  final LeaderboardViewState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double horizontalPadding = ResponsiveBuilder.value<double>(
      context,
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxl,
    );
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720.0,
      desktop: 960.0,
    );

    Widget content;
    if (state.isLoading && state.categories.isEmpty) {
      content = const LeaderboardLoadingState();
    } else if (state.status == LeaderboardStatus.error &&
        state.categories.isEmpty) {
      content = LeaderboardErrorState(
        message: state.errorMessage ?? '',
        onRetry: onRefresh,
      );
    } else if (state.categories.isEmpty) {
      content = LeaderboardEmptyState(onAction: onRefresh);
    } else {
      content = RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    strings.LeaderboardStrings.hubSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final LeaderboardCategoryEntity category
                      in state.categories)
                    LeaderboardCard(
                      category: category,
                      onTap: () {
                        ref
                            .read(leaderboardControllerProvider.notifier)
                            .selectScope(category.scope);
                        context.goNamed(AppRoutes.leaderboardDetail,
                            pathParameters: <String, String>{
                              'scope': category.scope.name,
                            });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }
}
