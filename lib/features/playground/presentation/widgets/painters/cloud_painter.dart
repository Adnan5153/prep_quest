import 'package:flutter/material.dart';

enum CloudPainterKind { fluffy, thin, storm, golden }

class CloudPainter extends CustomPainter {
  CloudPainter({
    required this.kind,
    required this.fill,
    required this.highlight,
    required this.seed,
  });

  static final Paint _blob = Paint();
  static final Paint _highlightPaint = Paint();

  final CloudPainterKind kind;
  final Color fill;
  final Color highlight;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    _blob.color = fill;
    final blobs = _blobsFor(kind);
    for (final blob in blobs) {
      final radiusX = size.width * blob.rx;
      final radiusY = size.height * blob.ry;
      final center = Offset(size.width * blob.cx, size.height * blob.cy);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: radiusX, height: radiusY),
        _blob,
      );
    }

    final seedHash = (seed * 9301 + 49297) % 233280;
    final jitter = (seedHash / 233280 - 0.5) * 4;
    final highlightPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(cx + jitter, cy - size.height * 0.18),
          width: size.width * 0.42,
          height: size.height * 0.18,
        ),
      );
    _highlightPaint.color = highlight;
    canvas.drawPath(highlightPath, _highlightPaint);
  }

  List<_BlobSpec> _blobsFor(CloudPainterKind k) {
    switch (k) {
      case CloudPainterKind.fluffy:
        return const <_BlobSpec>[
          _BlobSpec(0.30, 0.55, 0.45, 0.70),
          _BlobSpec(0.55, 0.40, 0.55, 0.85),
          _BlobSpec(0.78, 0.55, 0.45, 0.70),
          _BlobSpec(0.45, 0.70, 0.35, 0.50),
        ];
      case CloudPainterKind.thin:
        return const <_BlobSpec>[
          _BlobSpec(0.20, 0.55, 0.35, 0.40),
          _BlobSpec(0.45, 0.50, 0.40, 0.45),
          _BlobSpec(0.70, 0.55, 0.35, 0.40),
        ];
      case CloudPainterKind.storm:
        return const <_BlobSpec>[
          _BlobSpec(0.28, 0.45, 0.50, 0.80),
          _BlobSpec(0.55, 0.40, 0.55, 0.90),
          _BlobSpec(0.80, 0.50, 0.45, 0.80),
        ];
      case CloudPainterKind.golden:
        return const <_BlobSpec>[
          _BlobSpec(0.30, 0.55, 0.40, 0.55),
          _BlobSpec(0.55, 0.40, 0.55, 0.75),
          _BlobSpec(0.78, 0.55, 0.40, 0.55),
        ];
    }
  }

  @override
  bool shouldRepaint(covariant CloudPainter old) {
    return old.kind != kind ||
        old.fill != fill ||
        old.highlight != highlight ||
        old.seed != seed;
  }
}

class _BlobSpec {
  const _BlobSpec(this.cx, this.cy, this.rx, this.ry);

  final double cx;
  final double cy;
  final double rx;
  final double ry;
}
