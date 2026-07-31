import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/playground/presentation/widgets/map/playground_camera.dart';

void main() {
  group('PlaygroundCamera', () {
    test('focusOn never throws when content exceeds viewport', () {
      // Mirrors the API-driven layout: many categories produce a world
      // that is wider than the viewport. The earlier implementation
      // threw `Invalid argument(s)` from `double.clamp` whenever
      // `minX > maxX` (content fits inside the viewport on one axis
      // but not the other).
      final camera = PlaygroundCamera();
      camera.focusOn(
        target: const Offset(640, 320),
        viewport: const Size(360, 640),
        content: const Size(2400, 1800),
        zoomOverride: 1.0,
      );
      expect(camera.translation.dx.isFinite, isTrue);
      expect(camera.translation.dy.isFinite, isTrue);
    });

    test('focusOn works when content fits inside the viewport', () {
      final camera = PlaygroundCamera();
      camera.focusOn(
        target: const Offset(100, 100),
        viewport: const Size(800, 1200),
        content: const Size(400, 600),
        zoomOverride: 1.0,
      );
      expect(camera.translation.dx.isFinite, isTrue);
      expect(camera.translation.dy.isFinite, isTrue);
    });

    test('focusOn widens bounds without overflowing with tall content', () {
      // 19 categories => worldSize.height grows well past the viewport.
      final camera = PlaygroundCamera();
      camera.focusOn(
        target: const Offset(180, 9000),
        viewport: const Size(360, 720),
        content: const Size(360, 12000),
        zoomOverride: 1.0,
      );
      expect(camera.translation.dx.isFinite, isTrue);
      expect(camera.translation.dy.isFinite, isTrue);
    });
  });
}
