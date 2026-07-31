import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../../quiz_api/data/datasources/quiz_api_quiz_engine_adapter.dart';
import '../../../quiz_api/presentation/providers/quiz_api_providers.dart';
import '../../data/models/quiz_model.dart' as engine;
import '../constants/quiz_strings.dart';
import '../providers/quiz_providers.dart';
import '../providers/quiz_progress_provider.dart';
import '../utils/quiz_visual_mapper.dart';
import '../widgets/quiz_overview/quiz_overview_card.dart';

/// Quiz Hub-backed "start screen" for a single playground node.
///
/// Phase 57. Tapping a playground world-map node now produces a
/// single synthesised quiz whose id is `quizhub-<categoryId>`. This
/// screen resolves the Quiz Hub category through
/// [quizApiQuizForCategoryProvider] and surfaces a single "Start"
/// card. The legacy [quizNodeControllerProvider] list path is still
/// available so any other entry point (e.g. an admin console deep
/// link) continues to work — when the Quiz Hub provider fails we
/// transparently fall back to the multi-quiz controller.
class QuizOverviewScreen extends ConsumerStatefulWidget {
  const QuizOverviewScreen({super.key, this.nodeId});

  final String? nodeId;

  @override
  ConsumerState<QuizOverviewScreen> createState() =>
      _QuizOverviewScreenState();
}

class _QuizOverviewScreenState extends ConsumerState<QuizOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final String? nodeId = widget.nodeId;
      if (nodeId == null || nodeId.isEmpty) {
        ref.read(quizListControllerProvider.notifier).load();
      } else if (!QuizApiQuizEngineAdapter.isQuizHubId(nodeId)) {
        // Legacy multi-quiz path — kept so existing deep-links still
        // resolve through the node-keyed controller.
        ref.read(quizNodeControllerProvider(nodeId).notifier).load(nodeId);
      }
      // Quiz Hub path: nothing to pre-load; the FutureProvider will
      // resolve on first read.
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? nodeId = widget.nodeId;

    return Scaffold(
      appBar: AppBar(
        title: Text(QuizStrings.overviewTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      QuizStrings.overviewTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      QuizStrings.overviewSubtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (nodeId != null && nodeId.isNotEmpty)
              _QuizHubOrLegacySliver(nodeId: nodeId)
            else
              const _AllQuizzesSliver(),
          ],
        ),
      ),
    );
  }
}

/// Picks the Quiz Hub single-quiz path when the adapter can resolve
/// the category, otherwise falls through to the legacy multi-quiz
/// controller so existing deep links keep working.
class _QuizHubOrLegacySliver extends ConsumerWidget {
  const _QuizHubOrLegacySliver({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<engine.QuizModel> quizHubAsync = ref.watch(
      quizApiQuizForCategoryProvider(nodeId),
    );

    if (quizHubAsync.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (quizHubAsync.hasValue) {
      return _QuizHubSliver(quiz: quizHubAsync.requireValue);
    }
    return _NodeQuizzesSliver(nodeId: nodeId);
  }
}

class _QuizHubSliver extends ConsumerWidget {
  const _QuizHubSliver({required this.quiz});

  final engine.QuizModel quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizProgressState progress =
        ref.watch(quizProgressControllerProvider);
    final bool isCompleted = progress.isCompleted(quiz.id);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          QuizOverviewCard(
            visual: QuizVisualMapper.toQuizCardVisual(quiz.toEntity()),
            completionRatio: isCompleted ? 1.0 : 0.0,
            onTap: () => context.goNamed(
              AppRoutes.quizPlay,
              queryParameters: <String, String>{'quizId': quiz.id},
            ),
          ),
        ]),
      ),
    );
  }
}

class _AllQuizzesSliver extends ConsumerWidget {
  const _AllQuizzesSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizListState state = ref.watch(quizListControllerProvider);
    final QuizProgressState progress =
        ref.watch(quizProgressControllerProvider);
    switch (state.status) {
      case QuizLoadStatus.initial:
      case QuizLoadStatus.loading:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      case QuizLoadStatus.error:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorView(
            message: state.errorMessage ?? 'Could not load quizzes',
            onRetry: () => ref.read(quizListControllerProvider.notifier).load(),
          ),
        );
      case QuizLoadStatus.ready:
        if (state.quizzes.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(message: QuizStrings.emptyQuizzes),
          );
        }
        return _QuizListSliver(
          quizzes: state.quizzes,
          isCompleted: (dynamic q) =>
              progress.isCompleted(q.id as String),
          onTap: (dynamic q) => context.goNamed(
            AppRoutes.quizPlay,
            queryParameters: <String, String>{'quizId': q.id as String},
          ),
        );
    }
  }
}

class _NodeQuizzesSliver extends ConsumerWidget {
  const _NodeQuizzesSliver({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizNodeState state = ref.watch(quizNodeControllerProvider(nodeId));
    final QuizProgressState progress =
        ref.watch(quizProgressControllerProvider);
    switch (state.status) {
      case QuizLoadStatus.initial:
      case QuizLoadStatus.loading:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      case QuizLoadStatus.error:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorView(
            message: state.errorMessage ?? 'Could not load quizzes',
            onRetry: () => ref
                .read(quizNodeControllerProvider(nodeId).notifier)
                .load(nodeId),
          ),
        );
      case QuizLoadStatus.ready:
        if (state.quizzes.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(message: QuizStrings.emptyForNode),
          );
        }
        return _QuizListSliver(
          quizzes: state.quizzes,
          isCompleted: (dynamic q) =>
              progress.isCompleted(q.id as String),
          onTap: (dynamic q) => context.goNamed(
            AppRoutes.quizPlay,
            queryParameters: <String, String>{'quizId': q.id as String},
          ),
        );
    }
  }
}

class _QuizListSliver extends StatelessWidget {
  const _QuizListSliver({
    required this.quizzes,
    required this.isCompleted,
    required this.onTap,
  });

  final List<dynamic> quizzes;
  final bool Function(dynamic) isCompleted;
  final void Function(dynamic) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      sliver: SliverList.separated(
        itemCount: quizzes.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (BuildContext context, int index) {
          final dynamic quiz = quizzes[index];
          return QuizOverviewCard(
            visual: QuizVisualMapper.toQuizCardVisual(quiz),
            completionRatio: isCompleted(quiz) ? 1.0 : 0.0,
            onTap: () => onTap(quiz),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(QuizStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.quiz_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}