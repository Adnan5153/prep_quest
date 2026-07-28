import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

enum AnimationProperty {
  translateX('translate_x'),
  translateY('translate_y'),
  scale('scale'),
  rotate('rotate'),
  opacity('opacity'),
  colorR('color_r'),
  colorG('color_g'),
  colorB('color_b'),
  custom('custom');

  const AnimationProperty(this.wire);

  final String wire;

  static AnimationProperty fromWire(String value) =>
      AnimationProperty.values.firstWhere(
        (AnimationProperty p) => p.wire == value,
        orElse: () => AnimationProperty.opacity,
      );
}

enum AnimationEasing {
  linear('linear'),
  easeIn('ease_in'),
  easeOut('ease_out'),
  easeInOut('ease_in_out'),
  cubicBezier('cubic_bezier');

  const AnimationEasing(this.wire);

  final String wire;

  static AnimationEasing fromWire(String value) =>
      AnimationEasing.values.firstWhere(
        (AnimationEasing e) => e.wire == value,
        orElse: () => AnimationEasing.easeInOut,
      );
}

@immutable
class AnimationKeyframe {
  const AnimationKeyframe({
    required this.timeMs,
    required this.value,
    required this.easing,
    this.bezierControlPoints,
  });

  final int timeMs;
  final double value;
  final AnimationEasing easing;
  final Map<String, double>? bezierControlPoints;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timeMs': timeMs,
        'value': value,
        'easing': easing.wire,
        'bezierControlPoints': bezierControlPoints,
      };

  factory AnimationKeyframe.fromJson(Map<String, dynamic> json) =>
      AnimationKeyframe(
        timeMs: (json['timeMs'] as num).toInt(),
        value: (json['value'] as num).toDouble(),
        easing: AnimationEasing.fromWire(json['easing'] as String),
        bezierControlPoints: json['bezierControlPoints'] == null
            ? null
            : Map<String, double>.from(
                (json['bezierControlPoints'] as Map).map(
                  (dynamic k, dynamic v) =>
                      MapEntry<String, double>(k as String, (v as num).toDouble()),
                ),
              ),
      );
}

@immutable
class AnimationTrack {
  const AnimationTrack({
    required this.property,
    required this.keyframes,
  });

  final AnimationProperty property;
  final List<AnimationKeyframe> keyframes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'property': property.wire,
        'keyframes': keyframes.map((AnimationKeyframe k) => k.toJson()).toList(),
      };

  factory AnimationTrack.fromJson(Map<String, dynamic> json) => AnimationTrack(
        property: AnimationProperty.fromWire(json['property'] as String),
        keyframes: (json['keyframes'] as List<dynamic>)
            .map((dynamic e) => AnimationKeyframe.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

@immutable
class AnimationEvent {
  const AnimationEvent({required this.timeMs, required this.name, this.payload});

  final int timeMs;
  final String name;
  final Map<String, dynamic>? payload;
}

@immutable
class AnimationEntity {
  const AnimationEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.durationMs,
    required this.tracks,
    required this.looping,
    required this.events,
    required this.updatedAt,
  });

  final String id;
  final String slug;
  final String displayName;
  final int durationMs;
  final List<AnimationTrack> tracks;
  final AnimationLoopMode looping;
  final List<AnimationEvent> events;
  final DateTime updatedAt;

  AnimationEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    int? durationMs,
    List<AnimationTrack>? tracks,
    AnimationLoopMode? looping,
    List<AnimationEvent>? events,
    DateTime? updatedAt,
  }) {
    return AnimationEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      durationMs: durationMs ?? this.durationMs,
      tracks: tracks ?? this.tracks,
      looping: looping ?? this.looping,
      events: events ?? this.events,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
