import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_background.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_camera.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_scroll_view.dart';
import '../../../../../../../../features/playground/presentation/widgets/painters/playground_path_painter.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_map_preview_data.dart';
import 'playground_preview_tile.dart';

class PlaygroundCameraPreview extends StatefulWidget {
  const PlaygroundCameraPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  State<PlaygroundCameraPreview> createState() =>
      _PlaygroundCameraPreviewState();
}

class _PlaygroundCameraPreviewState extends State<PlaygroundCameraPreview> {
  late final PlaygroundCamera _camera = PlaygroundCamera(
    zoom: widget.provider.playgroundCameraZoom.clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    ),
  );

  String? _lastSyncedFocusTarget;

  @override
  void didUpdateWidget(covariant PlaygroundCameraPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncFromProvider();
  }

  void _syncFromProvider() {
    final provider = widget.provider;
    final clamped = provider.playgroundCameraZoom.clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    );
    if (clamped != _camera.zoom) {
      _camera.setZoom(clamped);
    }
    final target = provider.playgroundCameraFocusTarget;
    if (target == _lastSyncedFocusTarget) return;
    _lastSyncedFocusTarget = target;
    final offset = PlaygroundMapPreviewFixtures.resolveCameraFocusTarget(
      target,
      PlaygroundMapPreviewFixtures.contentSize,
    );
    _camera.focusOn(
      target: offset,
      viewport: PlaygroundMapPreviewFixtures.stageSize,
      content: PlaygroundMapPreviewFixtures.contentSize,
    );
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final segments = PlaygroundMapPreviewFixtures.buildPathSegments();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Map Camera', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: widget.provider.playgroundCameraBrightness,
              padding: EdgeInsets.zero,
              child: _CameraStage(camera: _camera, segments: segments),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraStage extends StatelessWidget {
  const _CameraStage({required this.camera, required this.segments});

  final PlaygroundCamera camera;
  final List<PlaygroundPathSegment> segments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PlaygroundMapPreviewFixtures.stageSize.width,
      height: PlaygroundMapPreviewFixtures.stageSize.height,
      child: ClipRect(
        child: PlaygroundScrollView(
          camera: camera,
          contentSize: PlaygroundMapPreviewFixtures.contentSize,
          focusTarget: null,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              const Positioned.fill(
                child: PlaygroundBackground(biome: PlaygroundBiome.meadow),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _PathOverlayPainter(segments: segments),
                  ),
                ),
              ),
              Positioned(
                left: PlaygroundMapPreviewFixtures.startLandmark.dx,
                top: PlaygroundMapPreviewFixtures.startLandmark.dy,
                child: const _LandmarkDot(color: Color(0xFF77B255)),
              ),
              Positioned(
                left: PlaygroundMapPreviewFixtures.centerLandmark.dx,
                top: PlaygroundMapPreviewFixtures.centerLandmark.dy,
                child: const _LandmarkDot(color: Color(0xFFFFB400)),
              ),
              Positioned(
                left: PlaygroundMapPreviewFixtures.endLandmark.dx,
                top: PlaygroundMapPreviewFixtures.endLandmark.dy,
                child: const _LandmarkDot(color: Color(0xFFE74C3C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandmarkDot extends StatelessWidget {
  const _LandmarkDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x55000000), blurRadius: 4),
          ],
        ),
      ),
    );
  }
}

class _PathOverlayPainter extends CustomPainter {
  _PathOverlayPainter({required this.segments});
  final List<PlaygroundPathSegment> segments;

  static const Color _strokeColor = Color(0xFFFFFFFF);
  static const double _strokeAlpha = 0.7;
  static const double _strokeWidth = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _strokeColor.withValues(alpha: _strokeAlpha)
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final segment in segments) {
      final path = Path()
        ..moveTo(segment.start.dx, segment.start.dy)
        ..lineTo(segment.end.dx, segment.end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PathOverlayPainter old) {
    if (identical(old.segments, segments)) return false;
    if (old.segments.length != segments.length) return true;
    for (int i = 0; i < segments.length; i++) {
      final a = old.segments[i];
      final b = segments[i];
      if (a.start != b.start || a.end != b.end || a.state != b.state) {
        return true;
      }
    }
    return false;
  }
}
