import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/quiz_strings.dart';
import '../providers/quiz_providers.dart';
import '../providers/quiz_progress_provider.dart';
import '../utils/quiz_visual_mapper.dart';
import '../widgets/quiz_overview/quiz_overview_card.dart';

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
      if (nodeId != null && nodeId.isNotEmpty) {
        ref.read(quizNodeControllerProvider(nodeId).notifier).load(nodeId);
      } else {
        ref.read(quizListControllerProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? nodeId = widget.nodeId;
    final bool filterByNode = nodeId != null && nodeId.isNotEmpty;

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
            if (filterByNode)
              _NodeQuizzesSliver(nodeId: nodeId)
            else
              const _AllQuizzesSliver(),
          ],
        ),
      ),
    );
  }
}

class _AllQuizzesSliver extends ConsumerWidget {
  const _AllQuizzesSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizListState state = ref.watch(quizListControllerProvider);
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
        return _QuizListSliver(quizzes: state.quizzes);
    }
  }
}

class _NodeQuizzesSliver extends ConsumerWidget {
  const _NodeQuizzesSliver({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizNodeState state = ref.watch(quizNodeControllerProvider(nodeId));
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
        return _QuizListSliver(quizzes: state.quizzes);
    }
  }
}

class _QuizListSliver extends ConsumerWidget {
  const _QuizListSliver({required this.quizzes});

  final List<dynamic> quizzes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizProgressState progress =
        ref.watch(quizProgressControllerProvider);
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
          final String quizId = quiz.id as String;
          final bool isCompleted = progress.isCompleted(quizId);
          return QuizOverviewCard(
            visual: QuizVisualMapper.toQuizCardVisual(quiz),
            completionRatio: isCompleted ? 1.0 : 0.0,
            onTap: () => context.goNamed(
              AppRoutes.quizPlay,
              queryParameters: <String, String>{'quizId': quizId},
            ),
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