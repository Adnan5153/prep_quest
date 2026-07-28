import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/chart_axis_math.dart';
import '../../utils/statistics_visual_mapper.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
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
              painter: _BarPainter(
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

class _BarPainter extends CustomPainter {
  _BarPainter({
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
    final Rect chartRect = Rect.fromLTRB(
      leftPadding,
      topPadding,
      size.width - 8,
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
      final double y = chartRect.top + (chartRect.height * i / gridLines);
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

    final double slot = chartRect.width / points.length;
    final double barWidth = slot * 0.6;
    final Paint barPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color,
          color.withValues(alpha: 0.55),
        ],
      ).createShader(chartRect);

    for (int i = 0; i < points.length; i++) {
      final double normalized =
          (points[i].value / niceMax).clamp(0.0, 1.0);
      final double barHeight = chartRect.height * normalized;
      final double left =
          chartRect.left + slot * i + (slot - barWidth) / 2;
      final Rect barRect = Rect.fromLTRB(
        left,
        chartRect.bottom - barHeight,
        left + barWidth,
        chartRect.bottom,
      );
      final RRect rrect = RRect.fromRectAndCorners(
        barRect,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(rrect, barPaint);

      final TextPainter tp = TextPainter(
        text: TextSpan(text: points[i].label, style: TextStyle(color: labelColor, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          barRect.left + (barRect.width - tp.width) / 2,
          chartRect.bottom + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}