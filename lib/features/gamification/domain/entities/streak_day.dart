import 'package:flutter/foundation.dart';

import '../enums/streak_enums.dart';

/// A single day on the streak calendar.
@immutable
class StreakDay {
  const StreakDay({
    required this.date,
    required this.status,
  });

  final DateTime date;
  final StreakDayStatus status;

  int get dayOfMonth => date.day;

  bool get isToday {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  StreakDay copyWith({DateTime? date, StreakDayStatus? status}) {
    return StreakDay(
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}