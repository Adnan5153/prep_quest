import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';
import 'reward.dart';

/// One day in the 7-day daily reward calendar.
@immutable
class DailyRewardDay {
  const DailyRewardDay({
    required this.day,
    required this.status,
    required this.reward,
  });

  final int day;
  final DailyRewardStatus status;
  final DailyRewardEntry reward;
}