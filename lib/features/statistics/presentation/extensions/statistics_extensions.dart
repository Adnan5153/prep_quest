import '../../../../core/utils/date_utils.dart';

class StatisticsFormatters {
  const StatisticsFormatters._();

  static String duration(int seconds) => DateUtils.formatDuration(seconds);

  static String clock(int seconds) => DateUtils.secondsToClock(seconds);

  static String studyMinutes(int minutes) =>
      DateUtils.formatStudyMinutes(minutes);

  static String percent(int ratio) => '$ratio%';

  static String xp(int amount) {
    final String formatted = _compact(amount);
    return '$formatted XP';
  }

  static String _compact(int value) {
    if (value >= 1000000) {
      final double v = value / 1000000;
      return '${v.toStringAsFixed(v >= 10 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      final double v = value / 1000;
      return '${v.toStringAsFixed(v >= 10 ? 0 : 1)}k';
    }
    return value.toString();
  }
}