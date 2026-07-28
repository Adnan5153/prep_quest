import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';
import 'coordinate_entity.dart';

@immutable
class PathSegmentEntity {
  const PathSegmentEntity({
    required this.kind,
    required this.start,
    required this.end,
    this.control,
    this.width = 12,
    this.color,
  });

  final PathSegmentKind kind;
  final CoordinateEntity start;
  final CoordinateEntity end;
  final CoordinateEntity? control;
  final double width;
  final String? color;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'kind': kind.wire,
        'start': start.toJson(),
        'end': end.toJson(),
        'control': control?.toJson(),
        'width': width,
        'color': color,
      };

  factory PathSegmentEntity.fromJson(Map<String, dynamic> json) =>
      PathSegmentEntity(
        kind: PathSegmentKind.fromWire(json['kind'] as String),
        start: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['start'] as Map)),
        end: CoordinateEntity.fromJson(
            Map<String, dynamic>.from(json['end'] as Map)),
        control: json['control'] == null
            ? null
            : CoordinateEntity.fromJson(
                Map<String, dynamic>.from(json['control'] as Map)),
        width: (json['width'] as num? ?? 12).toDouble(),
        color: json['color'] as String?,
      );
}

@immutable
class WorldPathEntity {
  const WorldPathEntity({
    required this.id,
    required this.draftId,
    required this.fromNodeId,
    required this.toNodeId,
    required this.segments,
    this.style = PathStyle.bezier,
    this.assetId,
    this.visibleInThemes = const <String>[],
    this.locked = false,
  });

  final String id;
  final String draftId;
  final String fromNodeId;
  final String toNodeId;
  final List<PathSegmentEntity> segments;
  final PathStyle style;
  final String? assetId;
  final List<String> visibleInThemes;
  final bool locked;

  WorldPathEntity copyWith({
    String? id,
    String? draftId,
    String? fromNodeId,
    String? toNodeId,
    List<PathSegmentEntity>? segments,
    PathStyle? style,
    String? assetId,
    List<String>? visibleInThemes,
    bool? locked,
  }) {
    return WorldPathEntity(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      fromNodeId: fromNodeId ?? this.fromNodeId,
      toNodeId: toNodeId ?? this.toNodeId,
      segments: segments ?? this.segments,
      style: style ?? this.style,
      assetId: assetId ?? this.assetId,
      visibleInThemes: visibleInThemes ?? this.visibleInThemes,
      locked: locked ?? this.locked,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'draftId': draftId,
        'fromNodeId': fromNodeId,
        'toNodeId': toNodeId,
        'segments': segments.map((PathSegmentEntity s) => s.toJson()).toList(),
        'style': style.wire,
        'assetId': assetId,
        'visibleInThemes': visibleInThemes,
        'locked': locked,
      };

  factory WorldPathEntity.fromJson(Map<String, dynamic> json) => WorldPathEntity(
        id: json['id'] as String,
        draftId: json['draftId'] as String,
        fromNodeId: json['fromNodeId'] as String,
        toNodeId: json['toNodeId'] as String,
        style: PathStyle.fromWire(json['style'] as String),
        assetId: json['assetId'] as String?,
        segments: (json['segments'] as List<dynamic>)
            .map((dynamic e) => PathSegmentEntity.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
        visibleInThemes: (json['visibleInThemes'] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[],
        locked: json['locked'] as bool? ?? false,
      );
}
