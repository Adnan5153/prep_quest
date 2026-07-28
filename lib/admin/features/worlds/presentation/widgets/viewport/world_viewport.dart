import 'package:flutter/material.dart';

import '../../../../../core/theme/admin_palette.dart';
import '../../../../../shared/enums/workflow_state.dart';
import '../../../domain/entities/building_entity.dart';
import '../../../domain/entities/decoration_entity.dart';
import '../../../domain/entities/node_entity.dart';
import '../../../domain/entities/path_entity.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class WorldViewportPainter extends CustomPainter {
  WorldViewportPainter({
    required this.draft,
    required this.scale,
    required this.offsetX,
    required this.offsetY,
    required this.gridSize,
    required this.showGrid,
    required this.selectedNodeId,
    required this.selectedBuildingId,
    required this.selectedDecorationId,
    required this.selectedPathId,
    required this.themeTokens,
  });

  final WorldDraftEntity draft;
  final double scale;
  final double offsetX;
  final double offsetY;
  final double gridSize;
  final bool showGrid;
  final String? selectedNodeId;
  final String? selectedBuildingId;
  final String? selectedDecorationId;
  final String? selectedPathId;
  final Map<String, String> themeTokens;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    _drawGrid(canvas, size);
    _drawPaths(canvas);
    _drawBuildings(canvas);
    _drawDecorations(canvas);
    _drawNodes(canvas);

    canvas.restore();
  }

  void _drawGrid(Canvas canvas, Size size) {
    if (!showGrid) return;
    final Paint minor = Paint()
      ..color = AdminPalette.gridMinor
      ..strokeWidth = 1 / scale;
    final Paint major = Paint()
      ..color = AdminPalette.gridMajor
      ..strokeWidth = 1.2 / scale;
    final Rect worldRect = Rect.fromLTWH(
      (-offsetX) / scale,
      (-offsetY) / scale,
      size.width / scale,
      size.height / scale,
    );
    final double startX =
        (worldRect.left / gridSize).floor() * gridSize;
    final double endX = worldRect.right;
    final double startY =
        (worldRect.top / gridSize).floor() * gridSize;
    final double endY = worldRect.bottom;
    for (double x = startX; x <= endX; x += gridSize) {
      final Paint p = ((x / gridSize).round() % 4 == 0) ? major : minor;
      canvas.drawLine(Offset(x, worldRect.top), Offset(x, worldRect.bottom), p);
    }
    for (double y = startY; y <= endY; y += gridSize) {
      final Paint p = ((y / gridSize).round() % 4 == 0) ? major : minor;
      canvas.drawLine(Offset(worldRect.left, y), Offset(worldRect.right, y), p);
    }
  }

  void _drawPaths(Canvas canvas) {
    for (final WorldPathEntity path in draft.paths) {
      final Paint stroke = Paint()
        ..color = _hex(path.style.name == PathStyle.ribbon.wire
            ? '#C9A36B'
            : '#A57E50')
        ..strokeWidth = path.segments.isNotEmpty ? path.segments[0].width : 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (final PathSegmentEntity segment in path.segments) {
        if (segment.kind == PathSegmentKind.line) {
          canvas.drawLine(
            Offset(segment.start.x, segment.start.y),
            Offset(segment.end.x, segment.end.y),
            stroke,
          );
        } else if (segment.kind == PathSegmentKind.bezier) {
          final Offset c = segment.control != null
              ? Offset(segment.control!.x, segment.control!.y)
              : Offset(
                  (segment.start.x + segment.end.x) / 2,
                  (segment.start.y + segment.end.y) / 2,
                );
          final Path p = Path()
            ..moveTo(segment.start.x, segment.start.y)
            ..quadraticBezierTo(c.dx, c.dy, segment.end.x, segment.end.y);
          canvas.drawPath(p, stroke);
        }
      }
      if (path.id == selectedPathId) {
        final Paint glow = Paint()
          ..color = AdminPalette.selectionFill
          ..strokeWidth = 18
          ..style = PaintingStyle.stroke;
        for (final PathSegmentEntity segment in path.segments) {
          if (segment.control != null) {
            final Path p = Path()
              ..moveTo(segment.start.x, segment.start.y)
              ..quadraticBezierTo(segment.control!.x, segment.control!.y,
                  segment.end.x, segment.end.y);
            canvas.drawPath(p, glow);
          }
        }
      }
    }
  }

  void _drawBuildings(Canvas canvas) {
    for (final BuildingEntity b in draft.buildings) {
      final Rect rect = Rect.fromLTWH(
        b.coordinate.x - b.width / 2,
        b.coordinate.y - b.height / 2,
        b.width,
        b.height,
      );
      final Paint fill = Paint()..color = _hex(themeTokens['buildingPrimary'] ?? '#E8D5B7');
      final Paint stroke = Paint()
        ..color = _hex(themeTokens['buildingSecondary'] ?? '#A57E50')
        ..strokeWidth = 2 / scale
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        stroke,
      );
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: b.kind,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11 / scale,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: b.width - 8);
      tp.paint(
        canvas,
        Offset(rect.left + 4, rect.top + (b.height - tp.height) / 2),
      );
      if (b.id == selectedBuildingId) {
        final Paint glow = Paint()
          ..color = AdminPalette.selectionStroke
          ..strokeWidth = 2 / scale
          ..style = PaintingStyle.stroke;
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          glow,
        );
      }
    }
  }

  void _drawDecorations(Canvas canvas) {
    for (final DecorationEntity d in draft.decorations) {
      final double radius = 14 * d.scale;
      final Color base = _hex(_decorationColor(d.kind));
      final Paint fill = Paint()..color = base;
      final Paint stroke = Paint()
        ..color = Colors.black26
        ..strokeWidth = 1 / scale
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(d.coordinate.x, d.coordinate.y), radius, fill);
      canvas.drawCircle(Offset(d.coordinate.x, d.coordinate.y), radius, stroke);
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: _decorationGlyph(d.kind),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12 / scale,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          d.coordinate.x - tp.width / 2,
          d.coordinate.y - tp.height / 2,
        ),
      );
      if (d.id == selectedDecorationId) {
        final Paint glow = Paint()
          ..color = AdminPalette.selectionStroke
          ..strokeWidth = 2 / scale
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(
            Offset(d.coordinate.x, d.coordinate.y), radius + 4, glow);
      }
    }
  }

  void _drawNodes(Canvas canvas) {
    for (final NodeEntity n in draft.nodes) {
      final double radius = n.hasBossGate ? 26 : 18;
      final Color base = _nodeColor(n);
      final Paint fill = Paint()..color = base;
      final Paint stroke = Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..strokeWidth = 1.5 / scale
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(n.coordinate.x, n.coordinate.y), radius, fill);
      canvas.drawCircle(Offset(n.coordinate.x, n.coordinate.y), radius, stroke);
      if (n.levelNumber != null) {
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: '${n.levelNumber}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14 / scale,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            n.coordinate.x - tp.width / 2,
            n.coordinate.y - tp.height / 2,
          ),
        );
      }
      if (n.id == selectedNodeId) {
        final Paint glow = Paint()
          ..color = AdminPalette.selectionStroke
          ..strokeWidth = 2.5 / scale
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(
            Offset(n.coordinate.x, n.coordinate.y), radius + 6, glow);
        final Paint dashed = Paint()
          ..color = AdminPalette.selectionStroke.withValues(alpha: 0.5)
          ..strokeWidth = 1.2 / scale
          ..style = PaintingStyle.stroke;
        _drawDashedCircle(canvas, Offset(n.coordinate.x, n.coordinate.y),
            radius + 10, dashed);
      }
    }
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const int segments = 24;
    const double gapFraction = 0.45;
    for (int i = 0; i < segments; i++) {
      final double a1 = (i / segments) * 2 * 3.1415926;
      final double a2 = ((i + gapFraction) / segments) * 2 * 3.1415926;
      canvas.drawLine(
        Offset(center.dx + radius * _cos(a1), center.dy + radius * _sin(a1)),
        Offset(center.dx + radius * _cos(a2), center.dy + radius * _sin(a2)),
        paint,
      );
    }
  }

  double _cos(double r) => _trig(r, isCos: true);
  double _sin(double r) => _trig(r, isCos: false);
  double _trig(double r, {required bool isCos}) {
    final double x = r;
    final double n = x - (x ~/ (2 * 3.1415926)) * (2 * 3.1415926);
    return isCos ? _nativeCos(n) : _nativeSin(n);
  }

  double _nativeCos(double r) {
    double sum = 1;
    double term = 1;
    for (int i = 1; i < 12; i++) {
      term *= -r * r / ((2 * i - 1) * (2 * i));
      sum += term;
    }
    return sum;
  }

  double _nativeSin(double r) {
    double sum = r;
    double term = r;
    for (int i = 1; i < 12; i++) {
      term *= -r * r / ((2 * i) * (2 * i + 1));
      sum += term;
    }
    return sum;
  }

  Color _nodeColor(NodeEntity n) {
    if (n.hasBossGate) return _hex(themeTokens['bossGate'] ?? '#F5A623');
    switch (n.accessStatus) {
      case NodeAccessStatus.completed:
        return _hex(themeTokens['nodeCompleted'] ?? '#1B3B6F');
      case NodeAccessStatus.available:
        return _hex(themeTokens['nodeAvailable'] ?? '#0E7C4A');
      case NodeAccessStatus.locked:
        return _hex(themeTokens['nodeLocked'] ?? '#90A4AE');
    }
  }

  String _decorationColor(WorldObjectKind kind) {
    switch (kind) {
      case WorldObjectKind.tree:
        return '#2E7D32';
      case WorldObjectKind.bush:
        return '#388E3C';
      case WorldObjectKind.mountain:
        return '#5D4037';
      case WorldObjectKind.river:
        return '#1976D2';
      case WorldObjectKind.bridge:
        return '#8D6E63';
      case WorldObjectKind.flag:
        return '#0E7C4A';
      case WorldObjectKind.cloud:
        return '#FFFFFF';
      case WorldObjectKind.particleLayer:
        return '#FFF59D';
      case WorldObjectKind.rewardChest:
        return '#F5A623';
      case WorldObjectKind.decoration:
        return '#B0BEC5';
      default:
        return '#90A4AE';
    }
  }

  String _decorationGlyph(WorldObjectKind kind) {
    switch (kind) {
      case WorldObjectKind.tree:
        return '🌲';
      case WorldObjectKind.bush:
        return '🌿';
      case WorldObjectKind.mountain:
        return '⛰';
      case WorldObjectKind.river:
        return '~';
      case WorldObjectKind.bridge:
        return '⌒';
      case WorldObjectKind.flag:
        return '⚑';
      case WorldObjectKind.cloud:
        return '☁';
      case WorldObjectKind.particleLayer:
        return '✦';
      case WorldObjectKind.rewardChest:
        return '★';
      case WorldObjectKind.decoration:
        return '◆';
      default:
        return '·';
    }
  }

  Color _hex(String value) {
    final String v = value.replaceFirst('#', '');
    final int a = v.length == 8 ? int.parse(v.substring(0, 2), radix: 16) : 255;
    final int r = int.parse(v.substring(v.length - 6, v.length - 4), radix: 16);
    final int g = int.parse(v.substring(v.length - 4, v.length - 2), radix: 16);
    final int b = int.parse(v.substring(v.length - 2), radix: 16);
    return Color.fromARGB(a, r, g, b);
  }

  @override
  bool shouldRepaint(covariant WorldViewportPainter old) =>
      old.draft != draft ||
      old.scale != scale ||
      old.offsetX != offsetX ||
      old.offsetY != offsetY ||
      old.gridSize != gridSize ||
      old.showGrid != showGrid ||
      old.selectedNodeId != selectedNodeId ||
      old.selectedBuildingId != selectedBuildingId ||
      old.selectedDecorationId != selectedDecorationId ||
      old.selectedPathId != selectedPathId ||
      old.themeTokens != themeTokens;
}

class WorldViewport extends StatefulWidget {
  const WorldViewport({
    super.key,
    required this.controller,
    required this.onTap,
    this.onAssetDrop,
    this.onObjectDrag,
  });

  final ValueNotifier<WorldEditorState> controller;
  final void Function(Offset worldPos) onTap;
  final void Function(String assetId, Offset worldPos)? onAssetDrop;
  final void Function(EditorSelection selection, Offset worldPos)? onObjectDrag;

  @override
  State<WorldViewport> createState() => _WorldViewportState();
}

class _WorldViewportState extends State<WorldViewport> {
  Offset? _dragStart;
  bool _draggingObject = false;
  EditorSelection _dragSelection = EditorSelection.none;

  Offset _toWorld(Offset local, ViewportState v) => Offset(
        (local.dx - v.offsetX) / v.scale,
        (local.dy - v.offsetY) / v.scale,
      );

  EditorSelection _selectionAt(WorldEditorState s, Offset world) {
    for (final NodeEntity n in s.draft.nodes) {
      if ((world - Offset(n.coordinate.x, n.coordinate.y)).distance < 24) {
        return EditorSelection(kind: SelectionKind.node, id: n.id);
      }
    }
    for (final BuildingEntity b in s.draft.buildings) {
      final Rect rect = Rect.fromLTWH(
        b.coordinate.x - b.width / 2,
        b.coordinate.y - b.height / 2,
        b.width,
        b.height,
      );
      if (rect.contains(world)) {
        return EditorSelection(kind: SelectionKind.building, id: b.id);
      }
    }
    for (final DecorationEntity d in s.draft.decorations) {
      if ((world - Offset(d.coordinate.x, d.coordinate.y)).distance < 18) {
        return EditorSelection(kind: SelectionKind.decoration, id: d.id);
      }
    }
    return EditorSelection.none;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (BuildContext context, _) {
          final WorldEditorState s = widget.controller.value;
          final ViewportState v = s.viewport;
          final Widget content = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (TapDownDetails d) {
              final Offset world = _toWorld(d.localPosition, v);
              widget.onTap(world);
            },
            onScaleStart: (ScaleStartDetails details) {
              _dragStart = details.localFocalPoint;
              final Offset world = _toWorld(details.localFocalPoint, v);
              final EditorSelection hit = _selectionAt(s, world);
              if (s.mode == EditorMode.select && !hit.isEmpty) {
                _draggingObject = true;
                _dragSelection = hit;
              } else {
                _draggingObject = false;
                _dragSelection = EditorSelection.none;
              }
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              if (details.pointerCount == 1) {
                if (_dragStart == null) {
                  _dragStart = details.localFocalPoint;
                  return;
                }
                if (_draggingObject) {
                  final Offset world = _toWorld(details.localFocalPoint, v);
                  widget.onObjectDrag?.call(_dragSelection, world);
                } else {
                  final Offset delta =
                      details.localFocalPoint - _dragStart!;
                  _dragStart = details.localFocalPoint;
                  widget.controller.value = widget.controller.value.copyWith(
                    viewport: v.copyWith(
                      offsetX: v.offsetX + delta.dx,
                      offsetY: v.offsetY + delta.dy,
                    ),
                  );
                }
              } else {
                final double newScale =
                    (v.scale * details.scale).clamp(0.25, 4.0);
                widget.controller.value = widget.controller.value.copyWith(
                  viewport: v.copyWith(scale: newScale),
                );
              }
            },
            onScaleEnd: (_) {
              _dragStart = null;
              _draggingObject = false;
              _dragSelection = EditorSelection.none;
            },
            child: MouseRegion(
              cursor: _draggingObject
                  ? SystemMouseCursors.grabbing
                  : SystemMouseCursors.grab,
              child: Container(
                color: AdminPalette.canvasPaper,
                child: CustomPaint(
                  painter: WorldViewportPainter(
                    draft: s.draft,
                    scale: v.scale,
                    offsetX: v.offsetX,
                    offsetY: v.offsetY,
                    gridSize: v.gridSize,
                    showGrid: v.showGrid,
                    selectedNodeId: s.selection.kind == SelectionKind.node
                        ? s.selection.id
                        : null,
                    selectedBuildingId:
                        s.selection.kind == SelectionKind.building
                            ? s.selection.id
                            : null,
                    selectedDecorationId:
                        s.selection.kind == SelectionKind.decoration
                            ? s.selection.id
                            : null,
                    selectedPathId: s.selection.kind == SelectionKind.path
                        ? s.selection.id
                        : null,
                    themeTokens: const <String, String>{},
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          );
          final Widget droppable = DragTarget<String>(
            onWillAcceptWithDetails: (_) => true,
            onAcceptWithDetails: (DragTargetDetails<String> details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset local = box.globalToLocal(details.offset);
              final Offset world = _toWorld(local, v);
              widget.onAssetDrop?.call(details.data, world);
            },
            builder: (BuildContext context, List<String?> candidate,
                List<dynamic> rejected) {
              final bool hovering = candidate.isNotEmpty;
              return Container(
                decoration: hovering
                    ? BoxDecoration(
                        border: Border.all(
                            color: AdminPalette.accent, width: 2),
                      )
                    : null,
                child: content,
              );
            },
          );
          return droppable;
        },
      ),
    );
  }
}
