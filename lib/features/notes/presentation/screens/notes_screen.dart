import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_filter.dart';
import '../../domain/enums/note_sort.dart';
import '../providers/notes_filter_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/notes_state.dart';
import '../widgets/note_category_tabs.dart';
import '../widgets/note_empty_state.dart';
import '../widgets/note_error_state.dart';
import '../widgets/note_filter_sheet.dart';
import '../widgets/note_grid_item.dart';
import '../widgets/note_list_item.dart';
import '../widgets/note_loading_state.dart';
import '../widgets/note_search_bar.dart';
import '../widgets/note_share_sheet.dart';
import '../widgets/note_sort_sheet.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController _textController = TextEditingController();
  final Debouncer _debouncer =
      Debouncer(duration: const Duration(milliseconds: 320));
  late final NotesController _controller =
      ref.read(notesControllerProvider.notifier);
  StreamSubscription<NoteFeedback>? _feedbackSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.hydrate();
      _feedbackSub = _controller.feedback.listen(_handleFeedback);
    });
  }

  @override
  void dispose() {
    _feedbackSub?.cancel();
    _debouncer.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleFeedback(NoteFeedback feedback) {
    if (!mounted) return;
    switch (feedback.variant) {
      case NoteFeedbackVariant.error:
        AppSnackBar.showError(context, feedback.message);
        break;
      case NoteFeedbackVariant.created:
      case NoteFeedbackVariant.updated:
      case NoteFeedbackVariant.savedHighlight:
      case NoteFeedbackVariant.savedAi:
        AppSnackBar.showSuccess(context, feedback.message);
        break;
      default:
        AppSnackBar.showInfo(context, feedback.message);
    }
  }

  void _onQueryChanged(String value) {
    _controller.onQueryChanged(value);
    _debouncer(() {
      if (!mounted) return;
      _controller.runSearch();
    });
  }

  Future<void> _openFilterSheet(NoteFilter current) async {
    final NoteFilter? result = await NoteFilterSheet.show(
      context,
      initial: current,
    );
    if (result == null || !mounted) return;
    await _controller.onFilterChanged(result);
  }

  Future<void> _openSortSheet(NoteSort current) async {
    final NoteSort? result = await NoteSortSheet.show(
      context,
      initial: current,
    );
    if (result == null || !mounted) return;
    await _controller.onSortChanged(result);
  }

  void _onItemTap(NoteEntity note) {
    context.goNamed(
      AppRoutes.noteDetail,
      queryParameters: <String, String>{'id': note.id},
    );
  }

  void _onShare(NoteEntity note) {
    NoteShareSheet.show(context, note);
  }

  Future<void> _onCreate() async {
    await context.pushNamed(AppRoutes.noteCreate);
    if (!mounted) return;
    _controller.hydrate(offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final NotesViewState state = ref.watch(notesControllerProvider);
    final NoteFilter currentFilter = ref.watch(noteFilterProvider);
    final NoteSort currentSort = ref.watch(noteSortProvider);

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720,
      desktop: 960,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notesTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.profile),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.notesSortTitle,
            icon: const Icon(AppIcons.noteSort),
            onPressed: () => _openSortSheet(currentSort),
          ),
          IconButton(
            tooltip: AppStrings.notesFilterTitle,
            icon: const Icon(AppIcons.noteFilter),
            onPressed: () => _openFilterSheet(currentFilter),
          ),
          IconButton(
            tooltip: AppStrings.notesCreateCta,
            icon: const Icon(AppIcons.noteAdd),
            onPressed: _onCreate,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreate,
        icon: const Icon(AppIcons.noteAdd),
        label: const Text(AppStrings.notesCreateCta),
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
                  child: NoteSearchBar(
                    controller: _textController,
                    onChanged: _onQueryChanged,
                  ),
                ),
                NoteCategoryTabs(
                  selected: currentFilter,
                  onSelect: (NoteFilter f) => _controller.onFilterChanged(f),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NotesViewState state) {
    if (state.status == NotesStatus.loading && state.items.isEmpty) {
      return const NoteLoadingState();
    }
    if (state.status == NotesStatus.error) {
      return NoteErrorState(
        message: state.errorMessage ?? AppStrings.notesError,
        onRetry: () => _controller.hydrate(offset: 0),
      );
    }
    if (state.items.isEmpty && state.hasQuery) {
      return const NoteEmptyState(variant: NoteEmptyVariant.noSearch);
    }
    if (state.items.isEmpty) {
      return NoteEmptyState(
        onCreateNote: _onCreate,
        variant: NoteEmptyVariant.neverCreated,
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

  Widget _buildResultsView(NotesViewState state) {
    final int columns = ResponsiveBuilder.value<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
    if (columns == 1) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        itemCount: state.items.length,
        itemBuilder: (BuildContext context, int index) {
          final NoteEntity row = state.items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: NoteListItem(
              note: row,
              onTap: () => _onItemTap(row),
              onTogglePin: () => _controller.togglePinFor(row.id),
              onToggleFavorite: () => _controller.toggleFavoriteFor(row.id),
              onShare: () => _onShare(row),
            ),
          );
        },
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.6,
      ),
      itemCount: state.items.length,
      itemBuilder: (BuildContext context, int index) {
        final NoteEntity row = state.items[index];
        if (columns >= 3) {
          return NoteGridItem(
            note: row,
            onTap: () => _onItemTap(row),
            onTogglePin: () => _controller.togglePinFor(row.id),
            onToggleFavorite: () => _controller.toggleFavoriteFor(row.id),
            onShare: () => _onShare(row),
          );
        }
        return NoteGridItem(
          note: row,
          onTap: () => _onItemTap(row),
          onTogglePin: () => _controller.togglePinFor(row.id),
          onToggleFavorite: () => _controller.toggleFavoriteFor(row.id),
          onShare: () => _onShare(row),
        );
      },
    );
  }
}
