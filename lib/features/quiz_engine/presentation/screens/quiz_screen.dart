import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/question_progress_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';
import '../constants/quiz_constants.dart';
import '../constants/quiz_strings.dart';
import '../extensions/quiz_session_extensions.dart';
import '../providers/quiz_progress_provider.dart';
import '../providers/quiz_providers.dart';
import '../providers/quiz_session_provider.dart';
import '../providers/quiz_timer_provider.dart';
import '../widgets/quiz_option/quiz_option.dart';
import '../widgets/quiz_progress/quiz_progress_bar.dart';
import '../widgets/quiz_question/quiz_question_card.dart';
import '../widgets/quiz_timer/quiz_timer.dart';
import 'quiz_exit_confirmation_dialog.dart';
import 'quiz_pause_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.quizId});

  final String quizId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quizDetailControllerProvider(widget.quizId).notifier)
          .load(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final QuizDetailState detail =
        ref.watch(quizDetailControllerProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        title: Text(QuizStrings.screenTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(),
        ),
        actions: <Widget>[
          if (detail.quiz != null && detail.quiz!.isTimed) ...<Widget>[
            const _TimerBadge(),
            const SizedBox(width: AppSpacing.xs),
          ],
          IconButton(
            tooltip: QuizStrings.pauseQuiz,
            icon: const Icon(Icons.pause_circle_outline),
            onPressed: () => _togglePause(),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (detail.status) {
          QuizLoadStatus.initial ||
          QuizLoadStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          QuizLoadStatus.error => _ErrorView(
              message: detail.errorMessage ?? 'Could not load quiz',
              onRetry: () => ref
                  .read(quizDetailControllerProvider(widget.quizId).notifier)
                  .load(widget.quizId),
            ),
          QuizLoadStatus.ready => _LoadedQuiz(quizId: widget.quizId),
        },
      ),
    );
  }

  Future<void> _confirmExit() async {
    final QuizSessionController controller =
        ref.read(quizSessionControllerProvider(widget.quizId).notifier);
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => const QuizExitConfirmationDialog(),
    );
    if (shouldExit == true) {
      controller.abandon();
      if (mounted) context.goNamed(AppRoutes.playground);
    }
  }

  void _togglePause() {
    final QuizDetailState detail =
        ref.read(quizDetailControllerProvider(widget.quizId));
    final QuizEntity? quiz = detail.quiz;
    if (quiz == null || !quiz.isTimed) {
      ref
          .read(quizSessionControllerProvider(widget.quizId).notifier)
          .pause();
      _showPause();
    }
  }

  Future<void> _showPause() async {
    final QuizDetailState detail =
        ref.read(quizDetailControllerProvider(widget.quizId));
    final QuizEntity? quiz = detail.quiz;
    if (quiz == null) return;
    final QuizTimerKey key = QuizTimerKey(
      quizId: widget.quizId,
      totalSeconds: quiz.timeLimitSeconds ?? 0,
    );
    ref.read(quizTimerControllerProvider(key).notifier).pause();
    final bool? shouldResume = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => QuizPauseScreen(quizId: widget.quizId),
      ),
    );
    if (shouldResume == true) {
      ref.read(quizTimerControllerProvider(key).notifier).resume();
      ref
          .read(quizSessionControllerProvider(widget.quizId).notifier)
          .resume();
    }
  }
}

class _LoadedQuiz extends ConsumerStatefulWidget {
  const _LoadedQuiz({required this.quizId});

  final String quizId;

  @override
  ConsumerState<_LoadedQuiz> createState() => _LoadedQuizState();
}

class _LoadedQuizState extends ConsumerState<_LoadedQuiz> {
  @override
  Widget build(BuildContext context) {
    final QuizDetailState detail =
        ref.watch(quizDetailControllerProvider(widget.quizId));
    final QuizEntity? quiz = detail.quiz;
    if (quiz == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final QuizSessionEntity session =
        ref.watch(quizSessionControllerProvider(widget.quizId));
    final QuestionEntity? question = session.currentQuestion(quiz);
    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final int total = quiz.questions.length;
    final int currentIndex = session.currentIndex;
    final bool isLast = currentIndex >= total - 1;
    final bool revealCorrectness = session.isComplete;
    final QuestionProgressEntity? progress =
        session.progressFor(question.id);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: QuizLimits.readerMaxWidth,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            QuizProgressBar(
              currentIndex: currentIndex,
              total: total,
              answeredCount: session.answeredCount,
              flaggedCount: session.flaggedCount,
            ),
            const SizedBox(height: AppSpacing.lg),
            QuizQuestionCard(
              question: question,
              index: currentIndex,
              total: total,
              subject: quiz.subject,
              isFlagged: session.flags.contains(question.id),
              isBookmarked: progress?.isBookmarked ?? false,
              revealCorrectness: revealCorrectness,
              hintCount: question.hints.length,
              hintsRevealedCount: progress?.hintIdsRevealed.length ?? 0,
              onFlagToggle: () => ref
                  .read(quizSessionControllerProvider(widget.quizId).notifier)
                  .flagQuestion(question.id),
              onBookmarkToggle: () => ref
                  .read(quizProgressControllerProvider.notifier)
                  .toggleBookmark(question.id),
              onReport: () => context.goNamed(
                AppRoutes.quizPlay,
                queryParameters: <String, String>{'quizId': widget.quizId},
              ),
              onHintReveal: () => _revealNextHint(question, session),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...question.answers.map((answer) {
              final bool isSelected =
                  progress?.selectedAnswerIds.contains(answer.id) ?? false;
              final bool isCorrect = answer.isCorrect;
              final bool isLocked = revealCorrectness;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: QuizOption(
                  answer: answer,
                  index: question.answers.indexOf(answer),
                  isSelected: isSelected,
                  revealCorrectness: revealCorrectness,
                  isCorrectAnswer: isCorrect,
                  isMultiSelect: question.allowsMultipleAnswers,
                  isLocked: isLocked,
                  onSelected: () => ref
                      .read(quizSessionControllerProvider(widget.quizId)
                          .notifier)
                      .selectAnswer(question.id, answer.id),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            _NavBar(quizId: widget.quizId, isLast: isLast),
          ],
        ),
      ),
    );
  }

  void _revealNextHint(
    QuestionEntity question,
    QuizSessionEntity session,
  ) {
    final QuestionProgressEntity? progress =
        session.progressFor(question.id);
    final List<String> revealed = progress?.hintIdsRevealed ?? const <String>[];
    final String nextHint = question.hints
        .map((h) => h.id)
        .firstWhere(
          (id) => !revealed.contains(id),
          orElse: () => '',
        );
    if (nextHint.isEmpty) return;
    ref
        .read(quizSessionControllerProvider(widget.quizId).notifier)
        .revealHint(question.id, nextHint);
  }
}

class _TimerBadge extends ConsumerWidget {
  const _TimerBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizDetailState detail =
        ref.watch(quizDetailControllerProvider(
          (GoRouter.of(context).routerDelegate.currentConfiguration.uri
                      .queryParameters['quizId'] ??
                  '')
              .toString(),
        ));
    final QuizEntity? quiz = detail.quiz;
    if (quiz == null || !quiz.isTimed) return const SizedBox.shrink();
    final QuizTimerKey key = QuizTimerKey(
      quizId: quiz.id,
      totalSeconds: quiz.timeLimitSeconds ?? 0,
    );
    final QuizTimerSnapshot snapshot =
        ref.watch(quizTimerControllerProvider(key));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: QuizTimer(snapshot: snapshot, compact: true),
    );
  }
}

class _NavBar extends ConsumerWidget {
  const _NavBar({required this.quizId, required this.isLast});

  final String quizId;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizSessionEntity session =
        ref.watch(quizSessionControllerProvider(quizId));
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: session.canMovePrevious()
                  ? () => ref
                      .read(quizSessionControllerProvider(quizId).notifier)
                      .previous()
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: Text(QuizStrings.previousQuestion),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => ref
                  .read(quizSessionControllerProvider(quizId).notifier)
                  .skipQuestion(session.currentQuestionId),
              icon: const Icon(Icons.skip_next),
              label: Text(QuizStrings.skipQuestion),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: FilledButton.icon(
              onPressed: () async {
                if (isLast) {
                  ref
                      .read(quizSessionControllerProvider(quizId).notifier)
                      .next();
                  final QuizSessionEntity updated = ref
                      .read(quizSessionControllerProvider(quizId));
                  final QuizSessionEntity finalSession =
                      updated.copyWith(status: QuizSessionStatus.completed);
                  await ref
                      .read(quizResultControllerProvider.notifier)
                      .submit(finalSession);
                  ref
                      .read(quizProgressControllerProvider.notifier)
                      .markCompleted(quizId);
                  if (context.mounted) {
                    context.goNamed(
                      AppRoutes.quizResult,
                      queryParameters: <String, String>{'quizId': quizId},
                    );
                  }
                } else {
                  ref
                      .read(quizSessionControllerProvider(quizId).notifier)
                      .next();
                }
              },
              icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
              label: Text(isLast ? QuizStrings.submitQuiz : QuizStrings.nextQuestion),
            ),
          ),
        ],
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