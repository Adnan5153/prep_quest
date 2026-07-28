import 'package:flutter/foundation.dart';

/// User's level progression — XP accumulated toward the next tier.
@immutable
class LevelProgress {
  const LevelProgress({
    required this.currentLevel,
    required this.currentXP,
    required this.nextLevelXP,
  });

  final int currentLevel;
  final int currentXP;
  final int nextLevelXP;

  /// 0..1 progress toward the next level.
  double get ratio {
    if (nextLevelXP <= 0) return 1.0;
    return (currentXP / nextLevelXP).clamp(0.0, 1.0);
  }

  int get xpToNext => (nextLevelXP - currentXP).clamp(0, nextLevelXP);

  LevelProgress copyWith({int? currentLevel, int? currentXP, int? nextLevelXP}) {
    return LevelProgress(
      currentLevel: currentLevel ?? this.currentLevel,
      currentXP: currentXP ?? this.currentXP,
      nextLevelXP: nextLevelXP ?? this.nextLevelXP,
    );
  }
}