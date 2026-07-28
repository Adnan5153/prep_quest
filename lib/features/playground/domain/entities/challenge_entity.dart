/// Challenge categories understood by the Playground domain.
library;

enum ChallengeType { reading, quiz, miniBoss, aiTask, mock }

class ChallengeEntity {
  const ChallengeEntity({
    required this.id,
    required this.levelId,
    required this.title,
    required this.description,
    required this.type,
    this.questionIds = const <String>[],
    this.xpReward = 0,
    this.coinReward = 0,
    this.progress = 0,
    this.completedAt,
  });

  final String id;
  final String levelId;
  final String title;
  final String description;
  final ChallengeType type;
  final List<String> questionIds;
  final int xpReward;
  final int coinReward;

  /// Normalised progress from 0 to 1.
  final double progress;

  final DateTime? completedAt;

  bool get isCompleted => completedAt != null || progress >= 1;

  ChallengeEntity copyWith({
    String? id,
    String? levelId,
    String? title,
    String? description,
    ChallengeType? type,
    List<String>? questionIds,
    int? xpReward,
    int? coinReward,
    double? progress,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return ChallengeEntity(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      questionIds: questionIds ?? this.questionIds,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      progress: progress ?? this.progress,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChallengeEntity &&
        other.id == id &&
        other.levelId == levelId &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.questionIds == questionIds &&
        other.xpReward == xpReward &&
        other.coinReward == coinReward &&
        other.progress == progress &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        levelId,
        title,
        description,
        type,
        questionIds,
        xpReward,
        coinReward,
        progress,
        completedAt,
      );
}