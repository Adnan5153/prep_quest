import '../../domain/entities/challenge_entity.dart';

/// JSON-ready representation of [ChallengeEntity].
class ChallengeModel {
  const ChallengeModel({
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
  final double progress;
  final DateTime? completedAt;

  ChallengeEntity toEntity() {
    return ChallengeEntity(
      id: id,
      levelId: levelId,
      title: title,
      description: description,
      type: type,
      questionIds: List<String>.unmodifiable(questionIds),
      xpReward: xpReward,
      coinReward: coinReward,
      progress: progress,
      completedAt: completedAt,
    );
  }

  factory ChallengeModel.fromEntity(ChallengeEntity entity) {
    return ChallengeModel(
      id: entity.id,
      levelId: entity.levelId,
      title: entity.title,
      description: entity.description,
      type: entity.type,
      questionIds: List<String>.unmodifiable(entity.questionIds),
      xpReward: entity.xpReward,
      coinReward: entity.coinReward,
      progress: entity.progress,
      completedAt: entity.completedAt,
    );
  }

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'] as String? ?? '',
      levelId: map['levelId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: _typeFromString(map['type'] as String?),
      questionIds: ((map['questionIds'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      coinReward: (map['coinReward'] as num?)?.toInt() ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'levelId': levelId,
      'title': title,
      'description': description,
      'type': type.id,
      'questionIds': questionIds,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'progress': progress,
      'completedAt': completedAt?.toUtc().toIso8601String(),
    };
  }

  ChallengeModel copyWith({
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
    return ChallengeModel(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      questionIds: questionIds ?? this.questionIds,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      progress: progress ?? this.progress,
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  static ChallengeType _typeFromString(String? value) {
    switch (value) {
      case 'quiz':
        return ChallengeType.quiz;
      case 'miniBoss':
        return ChallengeType.miniBoss;
      case 'aiTask':
        return ChallengeType.aiTask;
      case 'mock':
        return ChallengeType.mock;
      case 'reading':
      default:
        return ChallengeType.reading;
    }
  }
}

extension on ChallengeType {
  String get id {
    switch (this) {
      case ChallengeType.reading:
        return 'reading';
      case ChallengeType.quiz:
        return 'quiz';
      case ChallengeType.miniBoss:
        return 'miniBoss';
      case ChallengeType.aiTask:
        return 'aiTask';
      case ChallengeType.mock:
        return 'mock';
    }
  }
}