import '../../../../core/extensions/date_extension.dart';
import '../../../../core/utils/date_utils.dart';

/// Pure formatters consumed by widgets in the Quiz Results feature.
class QuizResultFormatters {
  const QuizResultFormatters._();

  static String duration(int seconds) => seconds.asDuration();

  static String clock(int seconds) => seconds.asClock();

  static String percent(double ratio) =>
      '${(ratio * 100).round()}%';

  static String studyMinutes(int minutes) =>
      DateUtils.formatStudyMinutes(minutes);
}
