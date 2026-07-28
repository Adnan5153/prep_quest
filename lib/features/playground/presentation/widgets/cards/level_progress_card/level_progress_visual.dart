import 'level_progress_enums.dart';
import 'level_progress_reward.dart';

class LevelProgressVisual {
  const LevelProgressVisual({
    required this.level,
    required this.totalStages,
    required this.completedStages,
    required this.totalStars,
    required this.earnedStars,
    required this.currentXP,
    required this.requiredXP,
    this.state = LevelCardState.current,
    this.title,
    this.subtitle,
    this.reward,
    this.size = LevelCardSize.standard,
    this.heroTag = 'level-progress-card',
  });

  final int level;
  final int totalStages;
  final int completedStages;
  final int totalStars;
  final int earnedStars;
  final int currentXP;
  final int requiredXP;
  final LevelCardState state;
  final String? title;
  final String? subtitle;
  final LevelProgressReward? reward;
  final LevelCardSize size;
  final String heroTag;

  double get progress {
    if (requiredXP <= 0) return 0;
    return (currentXP / requiredXP).clamp(0.0, 1.0);
  }

  double get stageProgress {
    if (totalStages <= 0) return 0;
    return (completedStages / totalStages).clamp(0.0, 1.0);
  }

  bool get isInteractive =>
      state == LevelCardState.current || state == LevelCardState.premium;

  bool get isCompleted => state == LevelCardState.completed;
  bool get isLocked => state == LevelCardState.locked;
  bool get isPremium => state == LevelCardState.premium;
}
