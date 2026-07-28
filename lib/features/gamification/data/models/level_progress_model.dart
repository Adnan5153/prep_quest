import '../../domain/entities/level_progress.dart';

class LevelProgressModel {
  const LevelProgressModel({
    required this.currentLevel,
    required this.currentXP,
    required this.nextLevelXP,
  });

  final int currentLevel;
  final int currentXP;
  final int nextLevelXP;

  LevelProgress toEntity() {
    return LevelProgress(
      currentLevel: currentLevel,
      currentXP: currentXP,
      nextLevelXP: nextLevelXP,
    );
  }
}