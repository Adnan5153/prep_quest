import 'package:flutter/material.dart';

import '../widgets/painters/path_painter.dart';
import '../widgets/painters/playground_path_painter.dart';

class PlaygroundPathSegmentRequest {
  const PlaygroundPathSegmentRequest({
    required this.start,
    required this.end,
    required this.state,
    this.controlA,
    this.controlB,
    this.variant = PlaygroundPathVariant.curved,
  });

  final Offset start;
  final Offset end;
  final PlaygroundPathSegmentState state;
  final Offset? controlA;
  final Offset? controlB;
  final PlaygroundPathVariant variant;
}

class PathGenerator {
  const PathGenerator._();

  static Offset defaultControlA(Offset start, Offset end) {
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    return Offset(mid.dx, start.dy);
  }

  static Offset defaultControlB(Offset start, Offset end) {
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    return Offset(mid.dx, end.dy);
  }

  static PlaygroundPathSpec buildSpec(PlaygroundPathSegmentRequest request) {
    return PlaygroundPathSpec(
      start: request.start,
      end: request.end,
      state: request.state,
      controlA: request.controlA ?? defaultControlA(request.start, request.end),
      controlB: request.controlB ?? defaultControlB(request.start, request.end),
      variant: request.variant,
    );
  }

  static PlaygroundPathSegment asMapSegment(
    PlaygroundPathSegmentRequest request,
  ) {
    return PlaygroundPathSegment(
      start: request.start,
      end: request.end,
      state: request.state,
    );
  }
}
