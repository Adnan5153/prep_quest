import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';

class PieSlice {
  const PieSlice({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.slices,
    this.title,
    this.subtitle,
  });

  final List<PieSlice> slices;
  final String? title;
  final String? subtitle;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                  painter: _DonutPainter(
                    slices: slices,
                    holeColor: theme.cardColor,
                  ),
                  child: Center(
                    child: _TotalLabel(slices: slices),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final PieSlice slice in slices)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xxs,
                        ),
                        child: _LegendRow(slice: slice),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalLabel extends StatelessWidget {
  const _TotalLabel({required this.slices});

  final List<PieSlice> slices;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double total = slices.fold(0, (acc, s) => acc + s.value);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          total.round().toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text('Total', style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.slice});

  final PieSlice slice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: slice.color,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(slice.label, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.slices, required this.holeColor});

  final List<PieSlice> slices;
  final Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double total = slices.fold(0, (acc, s) => acc + s.value);
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final double radius = min(size.width, size.height) / 2 - 2;
    final Offset center = rect.center;
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    double startAngle = -pi / 2;

    if (total <= 0) {
      final Paint emptyPaint = Paint()..color = holeColor.withValues(alpha: 0.5);
      canvas.drawCircle(center, radius, emptyPaint);
      return;
    }

    for (final PieSlice slice in slices) {
      final double sweep = (slice.value / total) * 2 * pi;
      final Paint paint = Paint()..color = slice.color;
      canvas.drawArc(arcRect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    final Paint innerPaint = Paint()..color = holeColor;
    canvas.drawCircle(center, radius * 0.62, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.slices != slices || oldDelegate.holeColor != holeColor;
}