import 'package:flutter/foundation.dart';

/// Per-topic breakdown of a single quiz result.
@immutable
class TopicPerformanceEntity {
  const TopicPerformanceEntity({
    required this.topicId,
    required this.topicName,
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.averageTimeSeconds,
  });

  final String topicId;
  final String topicName;
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int averageTimeSeconds;

  /// Accuracy as an integer percentage (`0..100`).
  int get accuracyPercent {
    if (totalQuestions == 0) return 0;
    final double ratio = correctCount / totalQuestions;
    return (ratio * 100).round();
  }

  bool get isWeak => totalQuestions > 0 && accuracyPercent < 60;
  bool get isStrong => totalQuestions > 0 && accuracyPercent >= 80;
}
