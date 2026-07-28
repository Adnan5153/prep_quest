import 'package:flutter/material.dart';

import 'mission_card_enums.dart';
import 'mission_reward.dart';

class MissionVisual {
  const MissionVisual({
    required this.id,
    required this.title,
    required this.description,
    required this.required,
    required this.progress,
    required this.reward,
    this.state = MissionCardState.active,
    this.tag = MissionCardTag.none,
    this.size = MissionCardSize.standard,
    this.timerSecondsRemaining,
    this.icon,
  });

  final String id;
  final String title;
  final String description;
  final int required;
  final int progress;
  final MissionCardReward reward;
  final MissionCardState state;
  final MissionCardTag tag;
  final MissionCardSize size;
  final int? timerSecondsRemaining;
  final IconData? icon;

  double get completion {
    if (required <= 0) return 0;
    return (progress / required).clamp(0.0, 1.0);
  }

  bool get isCompleted => state == MissionCardState.completed;
  bool get isLocked => state == MissionCardState.locked;
  bool get isActive => state == MissionCardState.active;
  bool get isInteractive => state == MissionCardState.active;
  bool get hasTimer => timerSecondsRemaining != null && !isCompleted;
}
