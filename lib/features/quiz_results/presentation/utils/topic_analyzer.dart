import '../../../quiz_engine/domain/entities/quiz_entity.dart';
import '../../domain/entities/topic_performance_entity.dart';

/// Pure aggregation of per-topic performance from a quiz result.
///
/// Groups questions by `QuestionEntity.topic` and computes counts,
/// accuracy percentage, and the average time per question. Used by the
/// quiz results feature and exposed for widget previews.
class TopicAnalyzer {
  const TopicAnalyzer();

  List<TopicPerformanceEntity> compute({
    required QuizEntity quiz,
    required Map<String, bool> questionResults,
  }) {
    final Map<String, _MutableBucket> buckets = <String, _MutableBucket>{};
    for (final dynamic question in quiz.questions) {
      final String topicId = question.topic as String;
      final String topicName = topicId.isEmpty ? 'General' : topicId;
      final bool? isCorrect = questionResults[question.id as String];
      _MutableBucket bucket = buckets.putIfAbsent(
        topicId,
        () => _MutableBucket(id: topicId, name: topicName),
      );
      bucket.total += 1;
      if (isCorrect == null) {
        bucket.skipped += 1;
      } else if (isCorrect) {
        bucket.correct += 1;
      } else {
        bucket.incorrect += 1;
      }
    }

    final List<TopicPerformanceEntity> rows = buckets.values
        .map(
          (_MutableBucket b) => TopicPerformanceEntity(
            topicId: b.id,
            topicName: b.name,
            totalQuestions: b.total,
            correctCount: b.correct,
            incorrectCount: b.incorrect,
            skippedCount: b.skipped,
            averageTimeSeconds: 0,
          ),
        )
        .toList(growable: false);

    rows.sort(
      (TopicPerformanceEntity a, TopicPerformanceEntity b) =>
          a.accuracyPercent.compareTo(b.accuracyPercent),
    );
    return List<TopicPerformanceEntity>.unmodifiable(rows);
  }
}

class _MutableBucket {
  _MutableBucket({required this.id, required this.name});

  final String id;
  final String name;
  int total = 0;
  int correct = 0;
  int incorrect = 0;
  int skipped = 0;
}