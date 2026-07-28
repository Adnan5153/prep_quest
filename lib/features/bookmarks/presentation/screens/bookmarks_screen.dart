import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_sort.dart';
import '../providers/bookmark_filter_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/bookmark_state.dart';
import '../widgets/bookmark_card.dart';
import '../widgets/bookmark_category_tabs.dart';
import '../widgets/bookmark_empty_state.dart';
import '../widgets/bookmark_error_state.dart';
import '../widgets/bookmark_grid_item.dart';
import '../widgets/bookmark_loading.dart';
import '../widgets/bookmark_offline_banner.dart';
import '../widgets/bookmark_search_bar.dart';
import '../widgets/bookmark_sort_dropdown.dart';
import '../widgets/bookmark_tile.dart';
import '../widgets/bookmark_filter_sheet.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final TextEditingController _textController = TextEditingController();
  final Debouncer _debouncer =
      Debouncer(duration: const Duration(milliseconds: 320));
  late final BookmarkController _controller =
      ref.read(bookmarkControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.hydrate();
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _controller.onQueryChanged(value);
    _debouncer(() {
      if (!mounted) return;
      _controller.runSearch();
    });
  }

  Future<void> _openFilterSheet(BookmarkFilter current) async {
    final BookmarkFilter? result = await BookmarkFilterSheet.show(
      context,
      initial: current,
    );
    if (result == null || !mounted) return;
    await _controller.onFilterChanged(result);
  }

  void _onItemTap(BookmarkEntity entity) {
    context.goNamed(
      entity.routeName,
      queryParameters: Map<String, String>.from(entity.routeParams),
    );
  }

  Future<void> _onItemRemove(BookmarkEntity entity) async {
    await _controller.removeEntity(entity);
    if (!mounted) return;
    // The action button on the tile already surfaces a snackbar via the
    // controller's feedback stream, so we keep this branch silent to
    // avoid double-notifying the user.
  }

  @override
  Widget build(BuildContext context) {
    final BookmarksViewState state = ref.watch(bookmarkControllerProvider);
    final BookmarkFilter currentFilter = ref.watch(bookmarkFilterProvider);
    final BookmarkSort currentSort = ref.watch(bookmarkSortProvider);

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720,
      desktop: 960,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookmarksTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.profile),
        ),
        actions: <Widget>[
          BookmarkSortDropdown(
            selected: currentSort,
            onChanged: (BookmarkSort s) => _controller.onSortChanged(s),
          ),
          IconButton(
            tooltip: AppStrings.bookmarksFilterTitle,
            icon: const Icon(AppIcons.searchFilter),
            onPressed: () => _openFilterSheet(currentFilter),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: BookmarkSearchBar(
                    controller: _textController,
                    onChanged: _onQueryChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: BookmarkCategoryTabs(
                    selected: currentFilter,
                    onSelect: (BookmarkFilter f) => _controller.onFilterChanged(f),
                    counts: const <BookmarkFilter, int>{},
                  ),
                ),
                if (state.offlineMode) const BookmarkOfflineBanner(),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BookmarksViewState state) {
    if (state.status == BookmarksStatus.loading) {
      return const BookmarkLoading();
    }
    if (state.status == BookmarksStatus.error) {
      return BookmarkErrorState(
        message: state.errorMessage ?? AppStrings.bookmarksError,
        onRetry: () => _controller.refresh(),
      );
    }
    if (state.isEmpty) {
      return const BookmarkEmptyState();
    }
    if (!state.hasResults) {
      return BookmarkEmptyState(
        filtered: true,
        onClearFilter: () => _controller.onFilterChanged(BookmarkFilter.all),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _controller.refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification n) {
          final ScrollMetrics metrics = n.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
            _controller.loadMore();
          }
          return false;
        },
        child: _buildResultsView(state),
      ),
    );
  }

  Widget _buildResultsView(BookmarksViewState state) {
    final int columns = ResponsiveBuilder.value<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
    if (columns == 1) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: state.items.length,
        itemBuilder: (BuildContext context, int index) {
          final BookmarkEntity row = state.items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: BookmarkTile(
              entity: row,
              onTap: () => _onItemTap(row),
              onRemove: () => _onItemRemove(row),
            ),
          );
        },
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.6,
      ),
      itemCount: state.items.length,
      itemBuilder: (BuildContext context, int index) {
        final BookmarkEntity row = state.items[index];
        if (columns >= 3) {
          return BookmarkGridItem(entity: row, onTap: () => _onItemTap(row));
        }
        return BookmarkCard(
          entity: row,
          onTap: () => _onItemTap(row),
          onRemove: () => _onItemRemove(row),
        );
      },
    );
  }
}

