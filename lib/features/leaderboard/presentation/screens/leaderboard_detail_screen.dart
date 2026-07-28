import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../constants/leaderboard_strings.dart' as strings;
import '../providers/leaderboard_provider.dart';
import '../widgets/leaderboard_current_user_card/leaderboard_current_user_card.dart';
import '../widgets/leaderboard_empty_state/leaderboard_empty_state.dart';
import '../widgets/leaderboard_error_state/leaderboard_error_state.dart';
import '../widgets/leaderboard_filter_tabs/leaderboard_filter_tabs.dart';
import '../widgets/leaderboard_header/leaderboard_header.dart';
import '../widgets/leaderboard_loading_state/leaderboard_loading_state.dart';
import '../widgets/leaderboard_podium/leaderboard_podium.dart';
import '../widgets/leaderboard_progress_indicator/leaderboard_progress_indicator.dart';
import '../widgets/leaderboard_rank_tile/leaderboard_rank_tile.dart';
import '../widgets/leaderboard_search_bar/leaderboard_search_bar.dart';
import '../widgets/leaderboard_sort_sheet/leaderboard_sort_sheet.dart';
import '../widgets/leaderboard_statistics_card/leaderboard_statistics_card.dart';

/// Per-scope detail screen: header, podium, search, sortable list,
/// sticky current-user card.
class LeaderboardDetailScreen extends ConsumerStatefulWidget {
  const LeaderboardDetailScreen({super.key, required this.scope});

  final String scope;

  @override
  ConsumerState<LeaderboardDetailScreen> createState() =>
      _LeaderboardDetailScreenState();
}

class _LeaderboardDetailScreenState
    extends ConsumerState<LeaderboardDetailScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      LeaderboardScope? parsed;
      for (final LeaderboardScope s in LeaderboardScope.values) {
        if (s.name == widget.scope) {
          parsed = s;
          break;
        }
      }
      if (parsed != null) {
        ref.read(leaderboardControllerProvider.notifier).loadScope(parsed);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final LeaderboardScope? active =
        ref.read(leaderboardControllerProvider).activeScope;
    if (active != null) {
      await ref
          .read(leaderboardControllerProvider.notifier)
          .loadScope(active);
    }
  }

  void _openSort() {
    final LeaderboardViewState state =
        ref.read(leaderboardControllerProvider);
    LeaderboardSortSheet.show(
      context,
      active: state.sort,
      onSelected: (LeaderboardSort s) {
        ref.read(leaderboardControllerProvider.notifier).setSort(s);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LeaderboardViewState state =
        ref.watch(leaderboardControllerProvider);
    final LeaderboardCategoryEntity? category = state.activeCategory;
    final LeaderboardEntryEntity? currentUser = category?.currentUserEntry;
    final List<LeaderboardEntryEntity> visible = state.visibleEntries;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            LeaderboardHeader(
              title: category?.title ?? _scopeLabel(widget.scope),
              subtitle: category?.subtitle ?? '',
              participantCount: category?.totalParticipants,
              lastUpdatedIso: category?.lastUpdatedIso,
              onBack: () => context.goNamed(AppRoutes.leaderboard),
            ),
            SliverToBoxAdapter(
              child: _Body(
                state: state,
                onRefresh: _refresh,
                onOpenSort: _openSort,
                searchController: _searchController,
                onSearchChanged: (String q) {
                  ref
                      .read(leaderboardControllerProvider.notifier)
                      .setQuery(q);
                },
                onSwitchScope: (LeaderboardScope scope) {
                  context.goNamed(
                    AppRoutes.leaderboardDetail,
                    pathParameters: <String, String>{'scope': scope.name},
                  );
                },
              ),
            ),
            if (category != null && category.podium.isNotEmpty)
              SliverToBoxAdapter(
                child: LeaderboardPodium(entries: category.podium),
              ),
            if (currentUser != null && state.query.isEmpty)
              SliverToBoxAdapter(
                child: LeaderboardProgressIndicator(
                  fraction: _progressFraction(currentUser, visible),
                  xpToNextRank: _xpToNextRank(currentUser, visible),
                ),
              ),
            if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: LeaderboardEmptyState(onAction: _refresh),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final LeaderboardEntryEntity e = visible[index];
                      return LeaderboardRankTile(entry: e);
                    },
                    childCount: visible.length,
                  ),
                ),
              ),
            if (currentUser != null)
              SliverToBoxAdapter(
                child: LeaderboardCurrentUserCard(
                  entry: currentUser,
                  aboveXp: _xpToNextRank(currentUser, visible),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _scopeLabel(String name) {
    switch (name) {
      case 'friends':
        return strings.LeaderboardStrings.scopeFriends;
      case 'university':
        return strings.LeaderboardStrings.scopeUniversity;
      case 'national':
        return strings.LeaderboardStrings.scopeNational;
      case 'weekly':
        return strings.LeaderboardStrings.scopeWeekly;
      case 'seasonal':
        return strings.LeaderboardStrings.scopeSeasonal;
      default:
        return strings.LeaderboardStrings.hubTitle;
    }
  }

  double _progressFraction(
    LeaderboardEntryEntity current,
    List<LeaderboardEntryEntity> all,
  ) {
    final int idx = all.indexWhere((LeaderboardEntryEntity e) =>
        e.userId == current.userId);
    if (idx <= 0) return 1.0;
    final LeaderboardEntryEntity above = all[idx - 1];
    if (above.xp <= current.xp) return 1.0;
    final double diff = (above.xp - current.xp).toDouble();
    const double typicalStep = 500;
    return (1.0 - (diff / typicalStep)).clamp(0.0, 1.0);
  }

  int _xpToNextRank(
    LeaderboardEntryEntity current,
    List<LeaderboardEntryEntity> all,
  ) {
    final int idx = all.indexWhere((LeaderboardEntryEntity e) =>
        e.userId == current.userId);
    if (idx <= 0) return 0;
    final LeaderboardEntryEntity above = all[idx - 1];
    return (above.xp - current.xp).clamp(0, 1 << 30);
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.state,
    required this.onRefresh,
    required this.onOpenSort,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSwitchScope,
  });

  final LeaderboardViewState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onOpenSort;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<LeaderboardScope> onSwitchScope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final double horizontalPadding = ResponsiveBuilder.value<double>(
      context,
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxl,
    );

    if (state.isLoading && state.entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LeaderboardLoadingState(),
      );
    }
    if (state.status == LeaderboardStatus.error && state.entries.isEmpty) {
      return LeaderboardErrorState(
        message: state.errorMessage ?? '',
        onRetry: onRefresh,
      );
    }

    final LeaderboardCategoryEntity? category = state.activeCategory;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: horizontalPadding / 2),
      child: Column(
        children: <Widget>[
          LeaderboardFilterTabs(
            scopes: LeaderboardScope.values,
            active: state.activeScope ?? LeaderboardScope.friends,
            onChanged: onSwitchScope,
          ),
          const SizedBox(height: AppSpacing.sm),
          LeaderboardSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              const Spacer(),
              TextButton.icon(
                onPressed: onOpenSort,
                icon: const Icon(Icons.sort_rounded, size: 18),
                label: Text(
                  strings.LeaderboardStrings.sortTitle,
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          if (category != null)
            LeaderboardStatisticsCard(entries: category.entries),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}