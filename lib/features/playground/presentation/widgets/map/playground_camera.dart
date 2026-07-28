import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';

class PlaygroundCamera extends ChangeNotifier {
  PlaygroundCamera({
    double zoom = PlaygroundSizes.mapCameraDefaultZoom,
    Offset translation = Offset.zero,
    Matrix4? initialMatrix,
  }) : _zoom = zoom,
       _translation = translation,
       _matrix = _initialMatrix(initialMatrix, translation, zoom);

  static Matrix4 _initialMatrix(
    Matrix4? source,
    Offset translation,
    double zoom,
  ) {
    if (source != null) return source.clone();
    return Matrix4.identity()
      ..translateByDouble(translation.dx, translation.dy, 0.0, 1.0)
      ..scaleByDouble(zoom, zoom, zoom, 1.0);
  }

  double _zoom;
  Offset _translation;
  Matrix4 _matrix;

  double get zoom => _zoom;
  Offset get translation => _translation;
  Matrix4 get matrix => _matrix;

  void setFromTransformation(Matrix4 value) {
    final nextZoom = value.getMaxScaleOnAxis();
    final t = value.getTranslation();
    final nextTranslation = Offset(t.x, t.y);
    if (nextZoom == _zoom &&
        nextTranslation == _translation &&
        _matricesEqual(_matrix, value)) {
      return;
    }
    _matrix = Matrix4.copy(value);
    _zoom = nextZoom;
    _translation = nextTranslation;
    notifyListeners();
  }

  bool _matricesEqual(Matrix4 a, Matrix4 b) {
    final as = a.storage;
    final bs = b.storage;
    if (as.length != bs.length) return false;
    for (int i = 0; i < as.length; i++) {
      if (as[i] != bs[i]) return false;
    }
    return true;
  }

  void _rebuildMatrix() {
    _matrix = Matrix4.identity()
      ..translateByDouble(_translation.dx, _translation.dy, 0.0, 1.0)
      ..scaleByDouble(_zoom, _zoom, _zoom, 1.0);
  }

  void focusOn({
    required Offset target,
    required Size viewport,
    required Size content,
    double? zoomOverride,
    Duration duration = PlaygroundMapDurations.cameraFocus,
    Curve curve = PlaygroundMapCurves.cameraFocus,
  }) {
    final zoom = (zoomOverride ?? _zoom).clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    );

    final nextTranslation = _computeCenteredTranslation(
      target: target,
      viewport: viewport,
      content: content,
      zoom: zoom,
    );

    if (zoom == _zoom && nextTranslation == _translation) return;

    _zoom = zoom;
    _translation = nextTranslation;
    _rebuildMatrix();
    notifyListeners();
  }

  void snapTo({
    required Offset target,
    required Size viewport,
    required Size content,
    Duration duration = PlaygroundMapDurations.cameraSnap,
    Curve curve = PlaygroundMapCurves.cameraSnap,
  }) {
    focusOn(
      target: target,
      viewport: viewport,
      content: content,
      zoomOverride: _zoom,
      duration: duration,
      curve: curve,
    );
  }

  void reset({
    required Size viewport,
    required Size content,
    Duration duration = PlaygroundMapDurations.cameraSnap,
    Curve curve = PlaygroundMapCurves.cameraSnap,
  }) {
    focusOn(
      target: content.center(Offset.zero),
      viewport: viewport,
      content: content,
      zoomOverride: PlaygroundSizes.mapCameraDefaultZoom,
      duration: duration,
      curve: curve,
    );
  }

  void setZoom(double value) {
    final clamped = value.clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    );
    if (clamped == _zoom) return;
    _zoom = clamped;
    _rebuildMatrix();
    notifyListeners();
  }

  void setTranslation(Offset value) {
    if (value == _translation) return;
    _translation = value;
    _rebuildMatrix();
    notifyListeners();
  }

  Offset _computeCenteredTranslation({
    required Offset target,
    required Size viewport,
    required Size content,
    required double zoom,
  }) {
    final dx = viewport.width / 2 - target.dx * zoom;
    final dy = viewport.height / 2 - target.dy * zoom;
    final maxX = PlaygroundMapPadding.cameraSafeInset;
    final minX =
        viewport.width -
        content.width * zoom -
        PlaygroundMapPadding.cameraSafeInset;
    final maxY = PlaygroundMapPadding.cameraSafeInset;
    final minY =
        viewport.height -
        content.height * zoom -
        PlaygroundMapPadding.cameraSafeInset;
    final clampedX = content.width <= viewport.width
        ? (viewport.width - content.width * zoom) / 2
        : dx.clamp(minX, maxX);
    return Offset(clampedX, dy.clamp(minY, maxY));
  }
}
