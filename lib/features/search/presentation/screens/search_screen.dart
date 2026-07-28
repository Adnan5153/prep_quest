import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_item_entity.dart';
import '../../domain/entities/trending_search_entity.dart';
import '../../domain/enums/search_category.dart';
import '../providers/search_provider.dart';
import '../providers/search_state.dart';
import '../widgets/recent_search_section.dart';
import '../widgets/search_category_tabs.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_error.dart';
import '../widgets/search_field.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/search_loading.dart';
import '../widgets/search_result_list.dart';
import '../widgets/trending_search_section.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  final Debouncer _debouncer =
      Debouncer(duration: const Duration(milliseconds: 320));
  late final SearchController _controller =
      ref.read(searchControllerProvider.notifier);

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

  void _onQueryChanged(String query) {
    _controller.onQueryChanged(query);
    _debouncer(() {
      if (!mounted) return;
      _controller.runSearch();
    });
  }

  void _onSubmitted(String query) {
    _debouncer.dispose();
    _controller.runSearch(query: query);
  }

  Future<void> _openFilterSheet(SearchViewState state) async {
    final Set<SearchCategory>? result = await SearchFilterSheet.show(
      context,
      initial: _currentFilterSet(state),
    );
    if (result == null || !mounted) return;
    if (result.isEmpty) {
      _controller.onCategorySelected(SearchCategory.all);
      return;
    }
    if (result.length == 1) {
      _controller.onCategorySelected(result.first);
    } else {
      _controller.onCategorySelected(SearchCategory.all);
    }
  }

  Set<SearchCategory> _currentFilterSet(SearchViewState state) {
    if (state.selectedCategory == SearchCategory.all) {
      return const <SearchCategory>{};
    }
    return <SearchCategory>{state.selectedCategory};
  }

  Future<void> _onItemTap(SearchItemEntity item) async {
    final SearchItemEntity opened = await _controller.onItemOpened(item);
    if (!mounted) return;
    context.goNamed(opened.routeName);
  }

  void _onRecentTap(RecentSearchEntity entry) {
    _textController.text = entry.query;
    _textController.selection = TextSelection.collapsed(
      offset: entry.query.length,
    );
    _controller.onQueryChanged(entry.query);
    _controller.runSearch(query: entry.query);
  }

  void _onTrendingTap(TrendingSearchEntity entry) {
    _textController.text = entry.query;
    _textController.selection = TextSelection.collapsed(
      offset: entry.query.length,
    );
    _controller.onQueryChanged(entry.query);
    _controller.runSearch(query: entry.query);
  }

  Future<void> _onClearRecent() async {
    await _controller.clearRecent();
    if (!mounted) return;
    AppSnackBar.showInfo(context, AppStrings.searchHistoryCleared);
  }

  @override
  Widget build(BuildContext context) {
    final SearchViewState state = ref.watch(searchControllerProvider);
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720,
      desktop: 960,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.search),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.searchFilterTitle,
            icon: const Icon(AppIcons.searchFilter),
            onPressed: () => _openFilterSheet(state),
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
                  child: SearchField(
                    controller: _textController,
                    onChanged: _onQueryChanged,
                    onSubmitted: _onSubmitted,
                  ),
                ),
                if (state.hasQuery)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SearchCategoryTabs(
                      selected: state.selectedCategory,
                      onSelect: _controller.onCategorySelected,
                      counts: state.resultCounts,
                    ),
                  ),
                const Divider(height: 1),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SearchViewState state) {
    if (state.status == SearchStatus.loading) {
      return SearchLoading(query: state.query);
    }
    if (state.status == SearchStatus.error) {
      return SearchErrorView(
        message: state.errorMessage ?? AppStrings.searchErrorMessage,
        onRetry: () => _controller.runSearch(),
      );
    }
    if (state.hasQuery) {
      if (!state.hasAnyResults) {
        return SearchEmptyResults(query: state.query);
      }
      return SearchResultList(
        items: state.visibleResults,
        onTap: _onItemTap,
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        RecentSearchSection(
          items: state.recent,
          onTap: _onRecentTap,
          onClear: _onClearRecent,
        ),
        const SizedBox(height: AppSpacing.md),
        TrendingSearchSection(
          items: state.trending,
          onTap: _onTrendingTap,
        ),
      ],
    );
  }
}