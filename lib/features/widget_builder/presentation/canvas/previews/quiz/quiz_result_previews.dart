import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/glass_card.dart';
import '../../../../../../../features/quiz_engine/presentation/utils/quiz_visual_mapper.dart';
import '../../../../../../../features/quiz_results/domain/entities/rank_progress.dart';
import '../../../../../../../features/quiz_results/domain/entities/star_rating.dart';
import '../../../../../../../features/quiz_results/domain/entities/topic_performance_entity.dart';
import '../../../../../../../features/quiz_results/presentation/utils/quiz_results_visual_mapper.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_analysis/accuracy_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_analysis/time_analysis_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_components/motivational_banner.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_components/statistics_grid.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_rank/rank_progress_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_rewards/coin_reward_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_rewards/xp_reward_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_score/score_hero_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_score/star_reward_card.dart';
import '../../../../../../../features/quiz_results/presentation/widgets/result_topics/weak_topics_card.dart';
import '../../../providers/widget_builder_provider.dart';

class QuizResultHeroCardPreview extends StatelessWidget {
  const QuizResultHeroCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final visual = _sampleVisual(passed: true, scorePercent: 85);
    return ScoreHeroCard(visual: visual);
  }
}

class QuizResultStatsGridPreview extends StatelessWidget {
  const QuizResultStatsGridPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return StatisticsGrid(
      visual: QuizResultVisual(
        scorePercent: 85,
        correctCount: 8,
        incorrectCount: 1,
        skippedCount: 1,
        timeSpentSeconds: 120,
        totalQuestions: 10,
        passed: true,
        rewardXp: 50,
        rewardCoins: 25,
      ),
    );
  }
}

class QuizResultAccuracyCardPreview extends StatelessWidget {
  const QuizResultAccuracyCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return AccuracyCard(
      visual: AccuracyVisual(
        accuracyPercent: 85,
        correctCount: 8,
        incorrectCount: 1,
      ),
    );
  }
}

class QuizResultTimeAnalysisCardPreview extends StatelessWidget {
  const QuizResultTimeAnalysisCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return TimeAnalysisCard(
      visual: TimeAnalysisVisual(totalSeconds: 180, averageSeconds: 18),
    );
  }
}

class QuizResultRankProgressCardPreview extends StatelessWidget {
  const QuizResultRankProgressCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return RankProgressCard(
      visual: RankProgressVisual(
        rank: RankProgress(
          rankBefore: 'Bronze I',
          rankAfter: 'Bronze II',
          progressToNextRank: 0.65,
        ),
      ),
    );
  }
}

class QuizResultXpRewardPreview extends StatelessWidget {
  const QuizResultXpRewardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return XPRewardCard(visual: XPRewardVisual(amount: 50));
  }
}

class QuizResultCoinRewardPreview extends StatelessWidget {
  const QuizResultCoinRewardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return CoinRewardCard(visual: CoinRewardVisual(amount: 25));
  }
}

class QuizResultStarRewardPreview extends StatelessWidget {
  const QuizResultStarRewardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return StarRewardCard(
      stars: 4,
      scorePercent: 85,
    );
  }
}

class QuizResultWeakTopicsCardPreview extends StatelessWidget {
  const QuizResultWeakTopicsCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return WeakTopicsCard(
      visual: TopicBreakdownVisual(
        title: 'Topics to Review',
        items: _sampleTopics(),
        accentIsError: true,
      ),
    );
  }
}

class QuizResultStrongTopicsCardPreview extends StatelessWidget {
  const QuizResultStrongTopicsCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return WeakTopicsCard(
      visual: TopicBreakdownVisual(
        title: 'Topics You Crushed',
        items: _sampleTopics(),
        accentIsError: false,
      ),
    );
  }
}

class QuizResultPerformanceSummaryCardPreview extends StatelessWidget {
  const QuizResultPerformanceSummaryCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('8/10 correct • 1 skipped'),
      ),
    );
  }
}

class QuizResultMotivationalBannerPreview extends StatelessWidget {
  const QuizResultMotivationalBannerPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return const MotivationalBanner(message: 'Outstanding work — keep pushing!');
  }
}

class QuizResultShareDialogPreview extends StatelessWidget {
  const QuizResultShareDialogPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Quiz Result', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Score: 85% (Passed)'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy to clipboard'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class QuizResultConfettiAnimationPreview extends StatelessWidget {
  const QuizResultConfettiAnimationPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.amber.shade200,
            Colors.green.shade200,
          ],
        ),
      ),
      child: const Text('Confetti Animation'),
    );
  }
}

List<TopicPerformanceEntity> _sampleTopics() {
  return <TopicPerformanceEntity>[
    const TopicPerformanceEntity(
      topicId: 'algebra',
      topicName: 'Algebra',
      totalQuestions: 4,
      correctCount: 1,
      incorrectCount: 2,
      skippedCount: 1,
      averageTimeSeconds: 20,
    ),
    const TopicPerformanceEntity(
      topicId: 'geometry',
      topicName: 'Geometry',
      totalQuestions: 3,
      correctCount: 2,
      incorrectCount: 1,
      skippedCount: 0,
      averageTimeSeconds: 15,
    ),
  ];
}

QuizResultsVisual _sampleVisual({required bool passed, required int scorePercent}) {
  return QuizResultsVisual(
    base: QuizResultVisual(
      scorePercent: scorePercent,
      correctCount: 8,
      incorrectCount: 1,
      skippedCount: 1,
      timeSpentSeconds: 120,
      totalQuestions: 10,
      passed: passed,
      rewardXp: 50,
      rewardCoins: 25,
    ),
    accuracy: AccuracyVisual(
      accuracyPercent: scorePercent,
      correctCount: 8,
      incorrectCount: 1,
    ),
    time: TimeAnalysisVisual(totalSeconds: 120, averageSeconds: 12),
    weakTopics: TopicBreakdownVisual(
      title: 'Weak',
      items: _sampleTopics(),
      accentIsError: true,
    ),
    strongTopics: TopicBreakdownVisual(
      title: 'Strong',
      items: _sampleTopics(),
      accentIsError: false,
    ),
    stars: StarRewardVisual(
      stars: StarRating.fromScore(scorePercent),
      scorePercent: scorePercent,
    ),
    rank: RankProgressVisual(
      rank: RankProgress(
        rankBefore: 'Bronze I',
        rankAfter: passed ? 'Bronze II' : 'Bronze I',
        progressToNextRank: scorePercent / 100.0,
      ),
    ),
    xp: XPRewardVisual(amount: 50),
    coin: CoinRewardVisual(amount: 25),
    motivational: 'Outstanding work.',
    performanceSummary: '8/10 correct',
    passed: passed,
    scorePercent: scorePercent,
  );
}
