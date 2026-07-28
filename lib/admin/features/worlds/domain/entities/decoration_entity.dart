import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';
import 'coordinate_entity.dart';

@immutable
class DecorationEntity {
  const DecorationEntity({
    required this.id,
    required this.draftId,
    required this.kind,
    required this.coordinate,
    this.assetId,
    this.scale = 1,
    this.rotation = 0,
    this.parallaxLayer = 0,
    this.zIndex = 0,
    this.visibleInThemes = const <String>[],
    this.visibleInSeasons = const <String>[],
    this.linkedNodeId,
    this.metadata,
  });

  final String id;
  final String draftId;
  final WorldObjectKind kind;
  final CoordinateEntity coordinate;
  final String? assetId;
  final double scale;
  final double rotation;
  final int parallaxLayer;
  final int zIndex;
  final List<String> visibleInThemes;
  final List<String> visibleInSeasons;
  final String? linkedNodeId;
  final Map<String, dynamic>? metadata;

  DecorationEntity copyWith({
    String? id,
    String? draftId,
    WorldObjectKind? kind,
    CoordinateEntity? coordinate,
    String? assetId,
    double? scale,
    double? rotation,
    int? parallaxLayer,
    int? zIndex,
    List<String>? visibleInThemes,
    List<String>? visibleInSeasons,
    String? linkedNodeId,
    Map<String, dynamic>? metadata,
  }) {
    return DecorationEntity(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      kind: kind ?? this.kind,
      coordinate: coordinate ?? this.coordinate,
      assetId: assetId ?? this.assetId,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      parallaxLayer: parallaxLayer ?? this.parallaxLayer,
      zIndex: zIndex ?? this.zIndex,
      visibleInThemes: visibleInThemes ?? this.visibleInThemes,
      visibleInSeasons: visibleInSeasons ?? this.visibleInSeasons,
      linkedNodeId: linkedNodeId ?? this.linkedNodeId,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'draftId': draftId,
        'kind': kind.wire,
        'coordinate': coordinate.toJson(),
        'assetId': assetId,
        'scale': scale,
        'rotation': rotation,
        'parallaxLayer': parallaxLayer,
        'zIndex': zIndex,
        'visibleInThemes': visibleInThemes,
        'visibleInSeasons': visibleInSeasons,
        'linkedNodeId': linkedNodeId,
        'metadata': metadata,
      };

  factory DecorationEntity.fromJson(Map<String, dynamic> json) => DecorationEntity(
        id: json['id'] as String,
        draftId: json['draftId'] as String,
        kind: WorldObjectKind.fromWire(json['kind'] as String),
        coordinate: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['coordinate'] as Map)),
        assetId: json['assetId'] as String?,
        scale: (json['scale'] as num? ?? 1).toDouble(),
        rotation: (json['rotation'] as num? ?? 0).toDouble(),
        parallaxLayer: (json['parallaxLayer'] as num? ?? 0).toInt(),
        zIndex: (json['zIndex'] as num? ?? 0).toInt(),
        visibleInThemes: (json['visibleInThemes'] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[],
        visibleInSeasons: (json['visibleInSeasons'] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[],
        linkedNodeId: json['linkedNodeId'] as String?,
        metadata: json['metadata'] == null
            ? null
            : Map<String, dynamic>.from(json['metadata'] as Map),
      );
}
