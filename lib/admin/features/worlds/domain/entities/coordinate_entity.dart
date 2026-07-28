import 'package:flutter/foundation.dart';

@immutable
class CoordinateEntity {
  const CoordinateEntity({required this.x, required this.y, this.z = 0});

  final double x;
  final double y;
  final double z;

  CoordinateEntity copyWith({double? x, double? y, double? z}) =>
      CoordinateEntity(x: x ?? this.x, y: y ?? this.y, z: z ?? this.z);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'x': x, 'y': y, 'z': z};

  factory CoordinateEntity.fromJson(Map<String, dynamic> json) =>
      CoordinateEntity(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        z: (json['z'] as num? ?? 0).toDouble(),
      );
}
