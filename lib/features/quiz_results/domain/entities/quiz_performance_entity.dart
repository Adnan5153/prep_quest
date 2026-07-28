import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import 'rank_progress.dart';
import 'star_rating.dart';
import 'topic_performance_entity.dart';

/// Aggregate view of a single quiz's outcome. Composes the canonical
/// [QuizResultEntity] with derived analytics (per-topic breakdown,
/// star rating, rank delta, motivational summary).
class QuizPerformanceEntity {
  QuizPerformanceEntity({
    required this.result,
    required this.topicBreakdown,
    required this.averageTimePerQuestionSeconds,
    required this.completionPercent,
    required this.stars,
    required this.rankProgress,
    required this.motivationalMessage,
    required this.performanceSummary,
  });

  final QuizResultEntity result;
  final List<TopicPerformanceEntity> topicBreakdown;
  final int averageTimePerQuestionSeconds;
  final int completionPercent;
  final StarRating stars;
  final RankProgress rankProgress;
  final String motivationalMessage;
  final String performanceSummary;

  /// Resolves the originating session alongside the aggregated
  /// performance data when downstream code needs raw access.
  QuizSessionEntity? session;

  Iterable<TopicPerformanceEntity> get weakTopics =>
      topicBreakdown.where((TopicPerformanceEntity t) => t.isWeak);

  Iterable<TopicPerformanceEntity> get strongTopics =>
      topicBreakdown.where((TopicPerformanceEntity t) => t.isStrong);
}
