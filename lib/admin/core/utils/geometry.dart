import 'dart:math' as math;
import 'dart:ui';

class Point2D {
  const Point2D(this.x, this.y);

  final double x;
  final double y;

  Point2D operator +(Point2D other) => Point2D(x + other.x, y + other.y);
  Point2D operator -(Point2D other) => Point2D(x - other.x, y - other.y);
  Point2D operator *(double scalar) => Point2D(x * scalar, y * scalar);

  double distanceTo(Point2D other) {
    final double dx = x - other.x;
    final double dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  Point2D snapTo(double gridSize) => Point2D(
        (x / gridSize).round() * gridSize,
        (y / gridSize).round() * gridSize,
      );

  Offset toOffset() => Offset(x, y);

  Map<String, dynamic> toJson() => <String, dynamic>{'x': x, 'y': y};

  static Point2D fromJson(Map<String, dynamic> json) =>
      Point2D((json['x'] as num).toDouble(), (json['y'] as num).toDouble());
}

class Rect2D {
  const Rect2D({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  bool contains(Point2D point) =>
      point.x >= x && point.x <= x + width && point.y >= y && point.y <= y + height;

  Rect2D expandedBy(double amount) => Rect2D(
        x: x - amount,
        y: y - amount,
        width: width + amount * 2,
        height: height + amount * 2,
      );
}

class BezierSegment {
  const BezierSegment({
    required this.start,
    required this.control1,
    required this.control2,
    required this.end,
  });

  final Point2D start;
  final Point2D control1;
  final Point2D control2;
  final Point2D end;

  Point2D sample(double t) {
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double uuu = uu * u;
    final double ttt = tt * t;

    return Point2D(
      uuu * start.x +
          3 * uu * t * control1.x +
          3 * u * tt * control2.x +
          ttt * end.x,
      uuu * start.y +
          3 * uu * t * control1.y +
          3 * u * tt * control2.y +
          ttt * end.y,
    );
  }

  double approxLength({int steps = 24}) {
    double total = 0;
    Point2D previous = start;
    for (int i = 1; i <= steps; i++) {
      final double t = i / steps;
      final Point2D current = sample(t);
      total += previous.distanceTo(current);
      previous = current;
    }
    return total;
  }
}

class GeometryUtils {
  const GeometryUtils._();

  static Point2D midpoint(Point2D a, Point2D b) =>
      Point2D((a.x + b.x) / 2, (a.y + b.y) / 2);

  static BezierSegment autoCurve(Point2D from, Point2D to, {double bias = 0.55}) {
    final double midX = (from.x + to.x) / 2;
    final double midY = (from.y + to.y) / 2;
    final double dx = to.x - from.x;
    final double dy = to.y - from.y;
    final double length = math.sqrt(dx * dx + dy * dy);
    final double perpX = length == 0 ? 0 : -dy / length;
    final double perpY = length == 0 ? 0 : dx / length;
    final double offset = length * bias * 0.18;

    final Point2D c1 = Point2D(midX + perpX * offset, midY + perpY * offset);
    final Point2D c2 = Point2D(midX - perpX * offset, midY - perpY * offset);

    return BezierSegment(start: from, control1: c1, control2: c2, end: to);
  }

  static double polylineLength(List<Point2D> points) {
    if (points.length < 2) return 0;
    double total = 0;
    for (int i = 1; i < points.length; i++) {
      total += points[i - 1].distanceTo(points[i]);
    }
    return total;
  }
}
