import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/user_progress_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../../router.dart';
import '../../../gamification/domain/entities/reward_event.dart';
import '../../../gamification/domain/enums/reward_enums.dart';
import '../../../gamification/presentation/providers/rewards_provider.dart';
import '../../../gamification/presentation/widgets/rewards_celebration_dialogs.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../../../quiz_engine/presentation/providers/quiz_session_provider.dart';
import '../../domain/entities/quiz_performance_entity.dart';
import '../constants/quiz_results_strings.dart';
import '../providers/quiz_results_provider.dart';
import '../utils/quiz_results_visual_mapper.dart';
import '../widgets/result_analysis/accuracy_card.dart';
import '../widgets/result_analysis/time_analysis_card.dart';
import '../widgets/result_components/motivational_banner.dart';
import '../widgets/result_components/statistics_grid.dart';
import '../widgets/result_footer/result_footer.dart';
import '../widgets/result_rank/rank_progress_card.dart';
import '../widgets/result_rewards/coin_reward_card.dart';
import '../widgets/result_rewards/xp_reward_card.dart';
import '../widgets/result_score/score_hero_card.dart';
import '../widgets/result_topics/weak_topics_card.dart';

class QuizResultsScreen extends ConsumerStatefulWidget {
  const QuizResultsScreen({super.key, required this.quizId});

  final String quizId;

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final QuizSessionEntity session = ref.read(
        quizSessionControllerProvider(widget.quizId),
      );
      await ref
          .read(quizResultsControllerProvider(widget.quizId).notifier)
          .load(quizId: widget.quizId, session: session);
      if (!mounted) return;
      final QuizResultsState resultsState = ref.read(
        quizResultsControllerProvider(widget.quizId),
      );
      final QuizPerformanceEntity? performance = resultsState.performance;
      if (performance == null) return;
      await ref.read(userProgressServiceProvider).applyQuizCompletion(
            session: session,
            result: performance.result,
            categoryId: null,
          );
      if (!mounted) return;
      final QuizCompletedData data = QuizCompletedData(
        correctAnswers: performance.result.correctCount,
        totalQuestions: performance.result.questionResults.length,
        elapsedSeconds: performance.result.timeSpentSeconds,
        difficultyId: performance.result.difficulty.name,
        isPerfect: performance.result.isPerfect,
        streakDays:
            ref.read(profileControllerProvider).profile?.progression.streakDays ?? 0,
      );
      await ref
          .read(rewardsControllerProvider.notifier)
          .grantFromEvent(trigger: RewardTrigger.quizCompleted, data: data);
      if (!mounted) return;
      final dynamic outcome =
          ref.read(rewardsControllerProvider).lastOutcome;
      if (outcome != null && outcome.celebration.showBadgeUnlock) {
        await BadgeUnlockCelebrationDialog.show(context, outcome: outcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final QuizResultsState state =
        ref.watch(quizResultsControllerProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        title: Text(QuizResultsStrings.screenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: switch (state.status) {
              QuizResultsLoadStatus.initial ||
              QuizResultsLoadStatus.loading =>
                const _LoadingView(),
              QuizResultsLoadStatus.error =>
                _ErrorView(message: state.errorMessage ?? 'Error'),
              QuizResultsLoadStatus.ready => _Loaded(quizId: widget.quizId),
            },
          ),
        ),
      ),
    );
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizResultsState state =
        ref.watch(quizResultsControllerProvider(quizId));
    final performance = state.performance;
    if (performance == null) return const _LoadingView();
    final visual = QuizResultsVisualMapper.toVisual(performance);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        ScoreHeroCard(visual: visual),
        const SizedBox(height: AppSpacing.lg),
        MotivationalBanner(message: visual.motivational),
        const SizedBox(height: AppSpacing.lg),
        StatisticsGrid(visual: visual.base),
        const SizedBox(height: AppSpacing.lg),
        AccuracyCard(visual: visual.accuracy),
        const SizedBox(height: AppSpacing.lg),
        TimeAnalysisCard(visual: visual.time),
        const SizedBox(height: AppSpacing.lg),
        RankProgressCard(visual: visual.rank),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            Expanded(child: XPRewardCard(visual: visual.xp)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: CoinRewardCard(visual: visual.coin)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        WeakTopicsCard(visual: visual.weakTopics),
        const SizedBox(height: AppSpacing.lg),
        ResultFooter(quizId: quizId),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text(QuizResultsStrings.loadingResults),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

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
          PrimaryButton(
            text: 'Retry',
            onPressed: () => context.goNamed(AppRoutes.playground),
          ),
        ],
      ),
    );
  }
}
