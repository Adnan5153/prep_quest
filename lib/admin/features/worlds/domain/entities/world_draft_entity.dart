import 'package:flutter/foundation.dart';

import 'building_entity.dart';
import 'coordinate_entity.dart';
import 'decoration_entity.dart';
import 'node_entity.dart';
import 'path_entity.dart';

@immutable
class WorldDraftEntity {
  const WorldDraftEntity({
    required this.id,
    required this.worldId,
    required this.baseVersionId,
    required this.branchName,
    required this.ownerId,
    required this.nodes,
    required this.decorations,
    required this.buildings,
    required this.paths,
    required this.updatedAt,
    this.lockHolderId,
    this.lockExpiresAt,
    this.compass = const CoordinateEntity(x: 0, y: 0),
    this.zoom = 1,
    this.selectedThemeId,
    this.versionCounter = 0,
  });

  final String id;
  final String worldId;
  final String baseVersionId;
  final String branchName;
  final String ownerId;
  final List<NodeEntity> nodes;
  final List<DecorationEntity> decorations;
  final List<BuildingEntity> buildings;
  final List<WorldPathEntity> paths;
  final CoordinateEntity compass;
  final double zoom;
  final String? selectedThemeId;
  final int versionCounter;
  final String? lockHolderId;
  final DateTime? lockExpiresAt;
  final DateTime updatedAt;

  WorldDraftEntity copyWith({
    String? id,
    String? worldId,
    String? baseVersionId,
    String? branchName,
    String? ownerId,
    List<NodeEntity>? nodes,
    List<DecorationEntity>? decorations,
    List<BuildingEntity>? buildings,
    List<WorldPathEntity>? paths,
    CoordinateEntity? compass,
    double? zoom,
    String? selectedThemeId,
    int? versionCounter,
    String? lockHolderId,
    DateTime? lockExpiresAt,
    DateTime? updatedAt,
  }) {
    return WorldDraftEntity(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      baseVersionId: baseVersionId ?? this.baseVersionId,
      branchName: branchName ?? this.branchName,
      ownerId: ownerId ?? this.ownerId,
      nodes: nodes ?? this.nodes,
      decorations: decorations ?? this.decorations,
      buildings: buildings ?? this.buildings,
      paths: paths ?? this.paths,
      compass: compass ?? this.compass,
      zoom: zoom ?? this.zoom,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
      versionCounter: versionCounter ?? this.versionCounter,
      lockHolderId: lockHolderId ?? this.lockHolderId,
      lockExpiresAt: lockExpiresAt ?? this.lockExpiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toPayload() => <String, dynamic>{
        'id': id,
        'worldId': worldId,
        'baseVersionId': baseVersionId,
        'branchName': branchName,
        'ownerId': ownerId,
        'compass': compass.toJson(),
        'zoom': zoom,
        'selectedThemeId': selectedThemeId,
        'versionCounter': versionCounter,
        'nodes': nodes.map((NodeEntity n) => n.toJson()).toList(),
        'decorations':
            decorations.map((DecorationEntity d) => d.toJson()).toList(),
        'buildings': buildings.map((BuildingEntity b) => b.toJson()).toList(),
        'paths': paths.map((WorldPathEntity p) => p.toJson()).toList(),
      };

  factory WorldDraftEntity.fromPayload(Map<String, dynamic> json) =>
      WorldDraftEntity(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        baseVersionId: json['baseVersionId'] as String,
        branchName: json['branchName'] as String? ?? 'main',
        ownerId: json['ownerId'] as String,
        compass: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['compass'] as Map? ??
                const <String, dynamic>{'x': 0, 'y': 0})),
        zoom: (json['zoom'] as num? ?? 1).toDouble(),
        selectedThemeId: json['selectedThemeId'] as String?,
        versionCounter: (json['versionCounter'] as num? ?? 0).toInt(),
        nodes: (json['nodes'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) =>
                NodeEntity.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        decorations: (json['decorations'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) =>
                DecorationEntity.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        buildings: (json['buildings'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) =>
                BuildingEntity.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        paths: (json['paths'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) =>
                WorldPathEntity.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        updatedAt: DateTime.now(),
      );
}
