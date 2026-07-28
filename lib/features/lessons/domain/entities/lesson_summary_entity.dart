import 'package:flutter/foundation.dart';

@immutable
class LessonSummaryEntity {
  const LessonSummaryEntity({
    required this.keyTakeaways,
    required this.nextSteps,
    this.recommendedChallengeId,
  });

  final List<String> keyTakeaways;
  final List<String> nextSteps;
  final String? recommendedChallengeId;
}