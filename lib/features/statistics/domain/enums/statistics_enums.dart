enum StatisticsRange { daily, weekly, monthly, allTime }

enum ChartType { line, bar, pie, ring, heatmap }

enum StatisticsLoadStatus { initial, loading, ready, error }

enum SubjectPriority { critical, high, moderate, strong }

extension SubjectPriorityX on SubjectPriority {
  String get id {
    switch (this) {
      case SubjectPriority.critical:
        return 'critical';
      case SubjectPriority.high:
        return 'high';
      case SubjectPriority.moderate:
        return 'moderate';
      case SubjectPriority.strong:
        return 'strong';
    }
  }
}