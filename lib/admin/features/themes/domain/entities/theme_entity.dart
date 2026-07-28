import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class ThemeTokens {
  const ThemeTokens({
    required this.skyTop,
    required this.skyBottom,
    required this.ground,
    required this.pathPrimary,
    required this.pathShadow,
    required this.buildingPrimary,
    required this.buildingSecondary,
    required this.nodeLocked,
    required this.nodeAvailable,
    required this.nodeCompleted,
    required this.bossGate,
    required this.particleColor,
    required this.cloudColor,
    required this.atmosphereTint,
    this.fontFamily,
  });

  final String skyTop;
  final String skyBottom;
  final String ground;
  final String pathPrimary;
  final String pathShadow;
  final String buildingPrimary;
  final String buildingSecondary;
  final String nodeLocked;
  final String nodeAvailable;
  final String nodeCompleted;
  final String bossGate;
  final String particleColor;
  final String cloudColor;
  final String atmosphereTint;
  final String? fontFamily;

  ThemeTokens copyWith({
    String? skyTop,
    String? skyBottom,
    String? ground,
    String? pathPrimary,
    String? pathShadow,
    String? buildingPrimary,
    String? buildingSecondary,
    String? nodeLocked,
    String? nodeAvailable,
    String? nodeCompleted,
    String? bossGate,
    String? particleColor,
    String? cloudColor,
    String? atmosphereTint,
    String? fontFamily,
  }) {
    return ThemeTokens(
      skyTop: skyTop ?? this.skyTop,
      skyBottom: skyBottom ?? this.skyBottom,
      ground: ground ?? this.ground,
      pathPrimary: pathPrimary ?? this.pathPrimary,
      pathShadow: pathShadow ?? this.pathShadow,
      buildingPrimary: buildingPrimary ?? this.buildingPrimary,
      buildingSecondary: buildingSecondary ?? this.buildingSecondary,
      nodeLocked: nodeLocked ?? this.nodeLocked,
      nodeAvailable: nodeAvailable ?? this.nodeAvailable,
      nodeCompleted: nodeCompleted ?? this.nodeCompleted,
      bossGate: bossGate ?? this.bossGate,
      particleColor: particleColor ?? this.particleColor,
      cloudColor: cloudColor ?? this.cloudColor,
      atmosphereTint: atmosphereTint ?? this.atmosphereTint,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'skyTop': skyTop,
        'skyBottom': skyBottom,
        'ground': ground,
        'pathPrimary': pathPrimary,
        'pathShadow': pathShadow,
        'buildingPrimary': buildingPrimary,
        'buildingSecondary': buildingSecondary,
        'nodeLocked': nodeLocked,
        'nodeAvailable': nodeAvailable,
        'nodeCompleted': nodeCompleted,
        'bossGate': bossGate,
        'particleColor': particleColor,
        'cloudColor': cloudColor,
        'atmosphereTint': atmosphereTint,
        'fontFamily': fontFamily,
      };

  factory ThemeTokens.fromJson(Map<String, dynamic> json) => ThemeTokens(
        skyTop: json['skyTop'] as String,
        skyBottom: json['skyBottom'] as String,
        ground: json['ground'] as String,
        pathPrimary: json['pathPrimary'] as String,
        pathShadow: json['pathShadow'] as String,
        buildingPrimary: json['buildingPrimary'] as String,
        buildingSecondary: json['buildingSecondary'] as String,
        nodeLocked: json['nodeLocked'] as String,
        nodeAvailable: json['nodeAvailable'] as String,
        nodeCompleted: json['nodeCompleted'] as String,
        bossGate: json['bossGate'] as String,
        particleColor: json['particleColor'] as String,
        cloudColor: json['cloudColor'] as String,
        atmosphereTint: json['atmosphereTint'] as String,
        fontFamily: json['fontFamily'] as String?,
      );
}

@immutable
class ThemeEntity {
  const ThemeEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.parentId,
    required this.tokens,
    required this.weather,
    required this.status,
    required this.updatedAt,
    this.assetPackId,
    this.seasonalWeight = 1,
  });

  final String id;
  final String slug;
  final String displayName;
  final String? parentId;
  final ThemeTokens tokens;
  final ThemeWeather weather;
  final WorkflowState status;
  final DateTime updatedAt;
  final String? assetPackId;
  final double seasonalWeight;

  ThemeEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    String? parentId,
    ThemeTokens? tokens,
    ThemeWeather? weather,
    WorkflowState? status,
    DateTime? updatedAt,
    String? assetPackId,
    double? seasonalWeight,
  }) {
    return ThemeEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      parentId: parentId ?? this.parentId,
      tokens: tokens ?? this.tokens,
      weather: weather ?? this.weather,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      assetPackId: assetPackId ?? this.assetPackId,
      seasonalWeight: seasonalWeight ?? this.seasonalWeight,
    );
  }
}
