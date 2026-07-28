import 'package:flutter/foundation.dart';

/// Per-mission progress record persisted by the repository.
@immutable
class MissionProgressEntity {
  const MissionProgressEntity({
    required this.missionId,
    required this.currentValue,
    required this.targetValue,
    required this.updatedAtIso,
    this.claimedAtIso,
  });

  final String missionId;
  final int currentValue;
  final int targetValue;
  final String updatedAtIso;
  final String? claimedAtIso;

  double get ratio =>
      targetValue <= 0 ? 1.0 : (currentValue / targetValue).clamp(0.0, 1.0);

  bool get isComplete => currentValue >= targetValue && targetValue > 0;

  MissionProgressEntity copyWith({
    int? currentValue,
    int? targetValue,
    String? updatedAtIso,
    String? claimedAtIso,
  }) {
    return MissionProgressEntity(
      missionId: missionId,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
      claimedAtIso: claimedAtIso ?? this.claimedAtIso,
    );
  }
}