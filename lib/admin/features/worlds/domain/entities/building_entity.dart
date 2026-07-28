import 'package:flutter/foundation.dart';

import 'coordinate_entity.dart';

@immutable
class BuildingEntity {
  const BuildingEntity({
    required this.id,
    required this.draftId,
    required this.kind,
    required this.coordinate,
    required this.width,
    required this.height,
    this.assetId,
    this.rotation = 0,
    this.linkedNodeId,
    this.metadata,
    this.visibleInThemes = const <String>[],
  });

  final String id;
  final String draftId;
  final String kind;
  final CoordinateEntity coordinate;
  final double width;
  final double height;
  final String? assetId;
  final double rotation;
  final String? linkedNodeId;
  final Map<String, dynamic>? metadata;
  final List<String> visibleInThemes;

  BuildingEntity copyWith({
    String? id,
    String? draftId,
    String? kind,
    CoordinateEntity? coordinate,
    double? width,
    double? height,
    String? assetId,
    double? rotation,
    String? linkedNodeId,
    Map<String, dynamic>? metadata,
    List<String>? visibleInThemes,
  }) {
    return BuildingEntity(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      kind: kind ?? this.kind,
      coordinate: coordinate ?? this.coordinate,
      width: width ?? this.width,
      height: height ?? this.height,
      assetId: assetId ?? this.assetId,
      rotation: rotation ?? this.rotation,
      linkedNodeId: linkedNodeId ?? this.linkedNodeId,
      metadata: metadata ?? this.metadata,
      visibleInThemes: visibleInThemes ?? this.visibleInThemes,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'draftId': draftId,
        'kind': kind,
        'coordinate': coordinate.toJson(),
        'width': width,
        'height': height,
        'assetId': assetId,
        'rotation': rotation,
        'linkedNodeId': linkedNodeId,
        'metadata': metadata,
        'visibleInThemes': visibleInThemes,
      };

  factory BuildingEntity.fromJson(Map<String, dynamic> json) => BuildingEntity(
        id: json['id'] as String,
        draftId: json['draftId'] as String,
        kind: json['kind'] as String? ?? 'academy',
        coordinate: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['coordinate'] as Map)),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        assetId: json['assetId'] as String?,
        rotation: (json['rotation'] as num? ?? 0).toDouble(),
        linkedNodeId: json['linkedNodeId'] as String?,
        metadata: json['metadata'] == null
            ? null
            : Map<String, dynamic>.from(json['metadata'] as Map),
        visibleInThemes: (json['visibleInThemes'] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[],
      );
}
