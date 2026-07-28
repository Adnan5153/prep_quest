import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/review_question_entity.dart';
import '../../domain/entities/review_session_entity.dart';
import '../constants/review_strings.dart';
import '../providers/review_provider.dart';
import '../widgets/recent_attempt_tile.dart';
import '../widgets/review_empty_state.dart';
import '../widgets/review_error_state.dart';
import '../widgets/review_filter_chip.dart';
import '../widgets/review_loading_state.dart';
import '../widgets/review_question_card.dart';
import '../widgets/review_statistics_card.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewListControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ReviewListState state = ref.watch(reviewListControllerProvider);

    ref.listen<ReviewListState>(reviewListControllerProvider, (
      ReviewListState? previous,
      ReviewListState next,
    ) {
      if (next.statistics != null) {
        ref
            .read(reviewBookmarkControllerProvider.notifier)
            .prime(_bookmarkSeed(next.sessions));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(ReviewStrings.screenTitle),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(reviewListControllerProvider.notifier).load();
          },
          child: switch (state.status) {
            ReviewLoadStatus.initial ||
            ReviewLoadStatus.loading =>
              const ReviewLoadingState(),
            ReviewLoadStatus.error => ReviewErrorState(
                message: state.errorMessage,
                onRetry: () => ref
                    .read(reviewListControllerProvider.notifier)
                    .load(),
              ),
            ReviewLoadStatus.ready => _ReviewBody(state: state),
          },
        ),
      ),
    );
  }

  Set<String> _bookmarkSeed(List<ReviewSessionEntity> sessions) {
    final Set<String> ids = <String>{};
    for (final ReviewSessionEntity session in sessions) {
      for (final ReviewQuestionEntity q in session.questions) {
        if (q.isBookmarked) ids.add(q.question.id);
      }
    }
    return ids;
  }
}

class _ReviewBody extends ConsumerWidget {
  const _ReviewBody({required this.state});

  final ReviewListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<ReviewQuestionEntity> questions = state.questions;
    final bool isFiltered = state.filter != ReviewFilter.all;
    final bool isEmpty = questions.isEmpty;
    final ReviewStatistics? stats = state.statistics;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      children: <Widget>[
        Text(
          ReviewStrings.screenSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (stats != null) ReviewStatisticsCard(statistics: stats),
        const SizedBox(height: AppSpacing.lg),
        _FilterRow(state: state),
        const SizedBox(height: AppSpacing.md),
        if (isEmpty)
          ReviewEmptyState(
            filtered: isFiltered,
            onPrimaryAction: () => ref
                .read(reviewListControllerProvider.notifier)
                .setFilter(ReviewFilter.all),
            primaryActionLabel:
                isFiltered ? ReviewStrings.filterAll : null,
          )
        else
          Column(
            children: <Widget>[
              for (final ReviewQuestionEntity entry in questions)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ReviewQuestionCard(
                    entry: entry,
                    onTap: () => context.goNamed(
                      AppRoutes.reviewDetail,
                      queryParameters: <String, String>{
                        'questionId': entry.question.id,
                        'quizId': entry.quizId,
                      },
                    ),
                    onToggleBookmark: () => ref
                        .read(reviewBookmarkControllerProvider.notifier)
                        .toggle(entry.question.id),
                  ),
                ),
              if (state.filter == ReviewFilter.all) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                _RecentSection(state: state),
              ],
            ],
          ),
      ],
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow({required this.state});

  final ReviewListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ReviewSessionEntity> sessions = state.sessions;
    final int correctCount = sessions.fold<int>(
      0,
      (int sum, ReviewSessionEntity s) => sum + s.correctCount,
    );
    final int incorrectCount = sessions.fold<int>(
      0,
      (int sum, ReviewSessionEntity s) =>
          sum + s.incorrectCount + s.skippedCount,
    );
    final int bookmarkedCount = sessions.fold<int>(
      0,
      (int sum, ReviewSessionEntity s) => sum + s.bookmarkedCount,
    );

    final List<_FilterSpec> specs = <_FilterSpec>[
      _FilterSpec(
        filter: ReviewFilter.all,
        label: ReviewStrings.filterAll,
        icon: Icons.dashboard_outlined,
        count: sessions.fold<int>(
          0,
          (int sum, ReviewSessionEntity s) => sum + s.questions.length,
        ),
      ),
      _FilterSpec(
        filter: ReviewFilter.correct,
        label: ReviewStrings.filterCorrect,
        icon: Icons.check_circle_outline,
        count: correctCount,
      ),
      _FilterSpec(
        filter: ReviewFilter.incorrect,
        label: ReviewStrings.filterIncorrect,
        icon: Icons.report_problem_outlined,
        count: incorrectCount,
      ),
      _FilterSpec(
        filter: ReviewFilter.bookmarked,
        label: ReviewStrings.filterBookmarked,
        icon: Icons.bookmark_outline,
        count: bookmarkedCount,
      ),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specs.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final _FilterSpec spec = specs[index];
          return ReviewFilterChip(
            label: spec.label,
            selected: spec.filter == state.filter,
            icon: spec.icon,
            count: spec.count,
            onTap: () => ref
                .read(reviewListControllerProvider.notifier)
                .setFilter(spec.filter),
          );
        },
      ),
    );
  }
}

class _FilterSpec {
  const _FilterSpec({
    required this.filter,
    required this.label,
    required this.icon,
    required this.count,
  });

  final ReviewFilter filter;
  final String label;
  final IconData icon;
  final int count;
}

class _RecentSection extends ConsumerStatefulWidget {
  const _RecentSection({required this.state});

  final ReviewListState state;

  @override
  ConsumerState<_RecentSection> createState() => _RecentSectionState();
}

class _RecentSectionState extends ConsumerState<_RecentSection> {
  Future<List<ReviewQuestionEntity>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<List<ReviewQuestionEntity>> _fetch() async {
    final result = await ref.read(getRecentQuestionsProvider).call();
    return result.valueOrNull ?? <ReviewQuestionEntity>[];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FutureBuilder<List<ReviewQuestionEntity>>(
      future: _future,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ReviewQuestionEntity>> snapshot,
      ) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final List<ReviewQuestionEntity> preview =
            snapshot.data!.take(3).toList();
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.schedule_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    ReviewStrings.sectionRecent,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final ReviewQuestionEntity r in preview)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: RecentAttemptTile(
                    entry: r,
                    onTap: () => context.goNamed(
                      AppRoutes.reviewDetail,
                      queryParameters: <String, String>{
                        'questionId': r.question.id,
                        'quizId': r.quizId,
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}