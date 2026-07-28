import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';
import 'coordinate_entity.dart';

@immutable
class GateRuleEntity {
  const GateRuleEntity({
    required this.kind,
    this.minLevel = 0,
    this.minHearts = 0,
    this.requiresPayment = false,
    this.requiredBadgeId,
    this.scheduleCron,
  });

  final String kind;
  final int minLevel;
  final int minHearts;
  final bool requiresPayment;
  final String? requiredBadgeId;
  final String? scheduleCron;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'kind': kind,
        'minLevel': minLevel,
        'minHearts': minHearts,
        'requiresPayment': requiresPayment,
        'requiredBadgeId': requiredBadgeId,
        'scheduleCron': scheduleCron,
      };

  factory GateRuleEntity.fromJson(Map<String, dynamic> json) =>
      GateRuleEntity(
        kind: json['kind'] as String? ?? 'none',
        minLevel: (json['minLevel'] as num? ?? 0).toInt(),
        minHearts: (json['minHearts'] as num? ?? 0).toInt(),
        requiresPayment: json['requiresPayment'] as bool? ?? false,
        requiredBadgeId: json['requiredBadgeId'] as String?,
        scheduleCron: json['scheduleCron'] as String?,
      );

  GateRuleEntity copyWith({
    String? kind,
    int? minLevel,
    int? minHearts,
    bool? requiresPayment,
    String? requiredBadgeId,
    String? scheduleCron,
  }) {
    return GateRuleEntity(
      kind: kind ?? this.kind,
      minLevel: minLevel ?? this.minLevel,
      minHearts: minHearts ?? this.minHearts,
      requiresPayment: requiresPayment ?? this.requiresPayment,
      requiredBadgeId: requiredBadgeId ?? this.requiredBadgeId,
      scheduleCron: scheduleCron ?? this.scheduleCron,
    );
  }
}

enum NodeAccessStatus { locked, available, completed }

@immutable
class NodeEntity {
  const NodeEntity({
    required this.id,
    required this.draftId,
    required this.kind,
    required this.coordinate,
    this.levelNumber,
    this.titleKey,
    this.subtitleKey,
    this.iconKey,
    this.prerequisiteNodeIds = const <String>[],
    this.rewardTableId,
    this.gateRule,
    this.assetId,
    this.animationId,
    this.themeOverrides = const <String, String>{},
    this.contentLocaleBundle,
    this.accessStatus = NodeAccessStatus.locked,
  });

  final String id;
  final String draftId;
  final WorldObjectKind kind;
  final CoordinateEntity coordinate;
  final int? levelNumber;
  final String? titleKey;
  final String? subtitleKey;
  final String? iconKey;
  final List<String> prerequisiteNodeIds;
  final String? rewardTableId;
  final GateRuleEntity? gateRule;
  final String? assetId;
  final String? animationId;
  final Map<String, String> themeOverrides;
  final Map<String, String>? contentLocaleBundle;
  final NodeAccessStatus accessStatus;

  bool get isNavigable => kind.isNavigable;
  bool get hasBossGate => kind == WorldObjectKind.bossGate;

  NodeEntity copyWith({
    String? id,
    String? draftId,
    WorldObjectKind? kind,
    CoordinateEntity? coordinate,
    int? levelNumber,
    String? titleKey,
    String? subtitleKey,
    String? iconKey,
    List<String>? prerequisiteNodeIds,
    String? rewardTableId,
    GateRuleEntity? gateRule,
    String? assetId,
    String? animationId,
    Map<String, String>? themeOverrides,
    Map<String, String>? contentLocaleBundle,
    NodeAccessStatus? accessStatus,
  }) {
    return NodeEntity(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      kind: kind ?? this.kind,
      coordinate: coordinate ?? this.coordinate,
      levelNumber: levelNumber ?? this.levelNumber,
      titleKey: titleKey ?? this.titleKey,
      subtitleKey: subtitleKey ?? this.subtitleKey,
      iconKey: iconKey ?? this.iconKey,
      prerequisiteNodeIds: prerequisiteNodeIds ?? this.prerequisiteNodeIds,
      rewardTableId: rewardTableId ?? this.rewardTableId,
      gateRule: gateRule ?? this.gateRule,
      assetId: assetId ?? this.assetId,
      animationId: animationId ?? this.animationId,
      themeOverrides: themeOverrides ?? this.themeOverrides,
      contentLocaleBundle: contentLocaleBundle ?? this.contentLocaleBundle,
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'draftId': draftId,
        'kind': kind.wire,
        'coordinate': coordinate.toJson(),
        'levelNumber': levelNumber,
        'titleKey': titleKey,
        'subtitleKey': subtitleKey,
        'iconKey': iconKey,
        'prerequisiteNodeIds': prerequisiteNodeIds,
        'rewardTableId': rewardTableId,
        'gateRule': gateRule?.toJson(),
        'assetId': assetId,
        'animationId': animationId,
        'themeOverrides': themeOverrides,
        'contentLocaleBundle': contentLocaleBundle,
        'accessStatus': accessStatus.name,
      };

  factory NodeEntity.fromJson(Map<String, dynamic> json) => NodeEntity(
        id: json['id'] as String,
        draftId: json['draftId'] as String,
        kind: WorldObjectKind.fromWire(json['kind'] as String),
        coordinate: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['coordinate'] as Map)),
        levelNumber: (json['levelNumber'] as num?)?.toInt(),
        titleKey: json['titleKey'] as String?,
        subtitleKey: json['subtitleKey'] as String?,
        iconKey: json['iconKey'] as String?,
        prerequisiteNodeIds: (json['prerequisiteNodeIds'] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[],
        rewardTableId: json['rewardTableId'] as String?,
        gateRule: json['gateRule'] == null
            ? null
            : GateRuleEntity.fromJson(
                Map<String, dynamic>.from(json['gateRule'] as Map)),
        assetId: json['assetId'] as String?,
        animationId: json['animationId'] as String?,
        themeOverrides: Map<String, String>.from(
            json['themeOverrides'] as Map? ?? const <String, String>{}),
        contentLocaleBundle: (json['contentLocaleBundle'] as Map?) == null
            ? null
            : Map<String, String>.from(json['contentLocaleBundle'] as Map),
        accessStatus: NodeAccessStatus.values.firstWhere(
          (NodeAccessStatus s) => s.name == json['accessStatus'],
          orElse: () => NodeAccessStatus.locked,
        ),
      );
}
