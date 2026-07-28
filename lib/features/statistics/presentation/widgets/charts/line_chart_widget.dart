import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/chart_axis_math.dart';
import '../../utils/statistics_visual_mapper.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    super.key,
    required this.points,
    required this.color,
    this.title,
    this.subtitle,
    this.valueSuffix = '',
  });

  final List<ChartPoint> points;
  final Color color;
  final String? title;
  final String? subtitle;
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            Text(title!, style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            )),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xxs),
            Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: Size.infinite,
              painter: _LinePainter(
                points: points,
                color: color,
                gridColor: theme.dividerColor,
                labelColor: theme.textTheme.bodySmall?.color ?? Colors.grey,
                valueSuffix: valueSuffix,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.points,
    required this.color,
    required this.gridColor,
    required this.labelColor,
    required this.valueSuffix,
  });

  final List<ChartPoint> points;
  final Color color;
  final Color gridColor;
  final Color labelColor;
  final String valueSuffix;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final double leftPadding = 36;
    final double bottomPadding = 24;
    final double topPadding = 8;
    final double rightPadding = 8;
    final Rect chartRect = Rect.fromLTRB(
      leftPadding,
      topPadding,
      size.width - rightPadding,
      size.height - bottomPadding,
    );

    final double maxValue = points
        .map((p) => p.value)
        .fold<double>(0, (acc, v) => v > acc ? v : acc);
    final double niceMax = maxValue <= 0 ? 1 : ChartAxisMath.niceCeiling(maxValue);

    final Paint gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    final int gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final double y = chartRect.top +
          (chartRect.height * i / gridLines);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      final double value = niceMax - (niceMax * i / gridLines);
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: value.round().toString(),
          style: TextStyle(color: labelColor, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    final double stepX = points.length == 1
        ? 0
        : chartRect.width / (points.length - 1);

    final Path linePath = Path();
    final List<Offset> positions = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final double normalized =
          (points[i].value / niceMax).clamp(0.0, 1.0);
      final double x = chartRect.left + stepX * i;
      final double y = chartRect.bottom - (chartRect.height * normalized);
      positions.add(Offset(x, y));
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }

    final Path fillPath = Path.from(linePath)
      ..lineTo(positions.last.dx, chartRect.bottom)
      ..lineTo(positions.first.dx, chartRect.bottom)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color.withValues(alpha: 0.32),
          color.withValues(alpha: 0.02),
        ],
      ).createShader(chartRect);
    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    final Paint dotPaint = Paint()..color = color;
    final Paint ringPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (final Offset p in positions) {
      canvas.drawCircle(p, 6, ringPaint);
      canvas.drawCircle(p, 3, dotPaint);
    }

    final TextStyle labelStyle =
        TextStyle(color: labelColor, fontSize: 10);
    for (int i = 0; i < points.length; i++) {
      final Offset p = positions[i];
      final TextPainter tp = TextPainter(
        text: TextSpan(text: points[i].label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final double labelX =
          (p.dx - tp.width / 2).clamp(chartRect.left, chartRect.right - tp.width);
      tp.paint(canvas, Offset(labelX, chartRect.bottom + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.gridColor != gridColor;
  }
}