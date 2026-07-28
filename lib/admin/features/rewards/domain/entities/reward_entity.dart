import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class RewardOutcome {
  const RewardOutcome({
    this.xp = 0,
    this.coins = 0,
    this.hearts = 0,
    this.gems = 0,
    this.badgeId,
  });

  final int xp;
  final int coins;
  final int hearts;
  final int gems;
  final String? badgeId;

  RewardOutcome copyWith({
    int? xp,
    int? coins,
    int? hearts,
    int? gems,
    String? badgeId,
  }) {
    return RewardOutcome(
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      hearts: hearts ?? this.hearts,
      gems: gems ?? this.gems,
      badgeId: badgeId ?? this.badgeId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'xp': xp,
        'coins': coins,
        'hearts': hearts,
        'gems': gems,
        'badgeId': badgeId,
      };

  factory RewardOutcome.fromJson(Map<String, dynamic> json) => RewardOutcome(
        xp: (json['xp'] as num? ?? 0).toInt(),
        coins: (json['coins'] as num? ?? 0).toInt(),
        hearts: (json['hearts'] as num? ?? 0).toInt(),
        gems: (json['gems'] as num? ?? 0).toInt(),
        badgeId: json['badgeId'] as String?,
      );
}

@immutable
class RewardRule {
  const RewardRule({
    required this.condition,
    required this.outcome,
  });

  final RewardCondition condition;
  final RewardOutcome outcome;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'condition': condition.wire, 'outcome': outcome.toJson()};

  factory RewardRule.fromJson(Map<String, dynamic> json) => RewardRule(
        condition: RewardCondition.fromWire(json['condition'] as String),
        outcome: RewardOutcome.fromJson(
            Map<String, dynamic>.from(json['outcome'] as Map)),
      );
}

@immutable
class RewardTable {
  const RewardTable({
    required this.id,
    required this.slug,
    required this.name,
    required this.rules,
    required this.updatedAt,
  });

  final String id;
  final String slug;
  final String name;
  final List<RewardRule> rules;
  final DateTime updatedAt;

  RewardTable copyWith({
    String? id,
    String? slug,
    String? name,
    List<RewardRule>? rules,
    DateTime? updatedAt,
  }) {
    return RewardTable(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      rules: rules ?? this.rules,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
