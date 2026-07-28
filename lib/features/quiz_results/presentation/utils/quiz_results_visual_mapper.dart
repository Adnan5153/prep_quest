import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../../quiz_engine/presentation/utils/quiz_visual_mapper.dart';
import '../../domain/entities/quiz_performance_entity.dart';
import '../../domain/entities/rank_progress.dart';
import '../../domain/entities/star_rating.dart';
import '../../domain/entities/topic_performance_entity.dart';

/// Pure visual descriptors consumed by the quiz results widgets.
/// Keeps presentation widgets free of business logic.
class QuizResultsVisualMapper {
  const QuizResultsVisualMapper._();

  static QuizResultsVisual toVisual(QuizPerformanceEntity performance) {
    final List<TopicPerformanceEntity> weak = performance.weakTopics.toList();
    final List<TopicPerformanceEntity> strong = performance.strongTopics.toList();
    return QuizResultsVisual(
      base: _base(performance.result),
      accuracy: AccuracyVisual(
        accuracyPercent: performance.completionPercent,
        correctCount: performance.result.correctCount,
        incorrectCount: performance.result.incorrectCount,
      ),
      time: TimeAnalysisVisual(
        totalSeconds: performance.result.timeSpentSeconds,
        averageSeconds: performance.averageTimePerQuestionSeconds,
      ),
      weakTopics: TopicBreakdownVisual(
        title: 'Topics to Review',
        items: weak,
        accentIsError: true,
      ),
      strongTopics: TopicBreakdownVisual(
        title: 'Topics You Crushed',
        items: strong,
        accentIsError: false,
      ),
      stars: StarRewardVisual(
        stars: performance.stars,
        scorePercent: performance.result.scorePercent,
      ),
      rank: RankProgressVisual(rank: performance.rankProgress),
      xp: XPRewardVisual(amount: performance.result.rewardXp),
      coin: CoinRewardVisual(amount: performance.result.rewardCoins),
      motivational: performance.motivationalMessage,
      performanceSummary: performance.performanceSummary,
      passed: performance.result.passed,
      scorePercent: performance.result.scorePercent,
    );
  }

  static QuizResultVisual _base(QuizResultEntity result) {
    return QuizResultVisual(
      scorePercent: result.scorePercent,
      correctCount: result.correctCount,
      incorrectCount: result.incorrectCount,
      skippedCount: result.skippedCount,
      timeSpentSeconds: result.timeSpentSeconds,
      totalQuestions: result.questionResults.length,
      passed: result.passed,
      rewardXp: result.rewardXp,
      rewardCoins: result.rewardCoins,
    );
  }
}

class QuizResultsVisual {
  const QuizResultsVisual({
    required this.base,
    required this.accuracy,
    required this.time,
    required this.weakTopics,
    required this.strongTopics,
    required this.stars,
    required this.rank,
    required this.xp,
    required this.coin,
    required this.motivational,
    required this.performanceSummary,
    required this.passed,
    required this.scorePercent,
  });

  final QuizResultVisual base;
  final AccuracyVisual accuracy;
  final TimeAnalysisVisual time;
  final TopicBreakdownVisual weakTopics;
  final TopicBreakdownVisual strongTopics;
  final StarRewardVisual stars;
  final RankProgressVisual rank;
  final XPRewardVisual xp;
  final CoinRewardVisual coin;
  final String motivational;
  final String performanceSummary;
  final bool passed;
  final int scorePercent;
}

class AccuracyVisual {
  const AccuracyVisual({
    required this.accuracyPercent,
    required this.correctCount,
    required this.incorrectCount,
  });

  final int accuracyPercent;
  final int correctCount;
  final int incorrectCount;
}

class TimeAnalysisVisual {
  const TimeAnalysisVisual({
    required this.totalSeconds,
    required this.averageSeconds,
  });

  final int totalSeconds;
  final int averageSeconds;
}

class TopicBreakdownVisual {
  const TopicBreakdownVisual({
    required this.title,
    required this.items,
    required this.accentIsError,
  });

  final String title;
  final List<TopicPerformanceEntity> items;
  final bool accentIsError;
}

class StarRewardVisual {
  const StarRewardVisual({required this.stars, required this.scorePercent});

  final StarRating stars;
  final int scorePercent;
}

class RankProgressVisual {
  const RankProgressVisual({required this.rank});

  final RankProgress rank;
}

class XPRewardVisual {
  const XPRewardVisual({required this.amount});

  final int amount;
}

class CoinRewardVisual {
  const CoinRewardVisual({required this.amount});

  final int amount;
}
