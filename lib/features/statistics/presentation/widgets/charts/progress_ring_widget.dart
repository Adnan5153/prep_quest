import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';

class ProgressRingData {
  const ProgressRingData({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class ProgressRingWidget extends StatelessWidget {
  const ProgressRingWidget({
    super.key,
    required this.rings,
    required this.centerLabel,
    required this.centerValue,
    this.title,
    this.subtitle,
  });

  final List<ProgressRingData> rings;
  final String? title;
  final String centerLabel;
  final String centerValue;
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
            children: <Widget>[
              SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                  painter: _RingsPainter(
                    rings: rings,
                    backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
                    centerLabelColor:
                        theme.textTheme.bodySmall?.color ?? Colors.grey,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          centerValue,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(centerLabel,
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final ProgressRingData ring in rings)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xxs,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: ring.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                ring.label,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              '${(ring.value * 100).round()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
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

class _RingsPainter extends CustomPainter {
  _RingsPainter({
    required this.rings,
    required this.backgroundColor,
    required this.centerLabelColor,
  });

  final List<ProgressRingData> rings;
  final Color backgroundColor;
  final Color centerLabelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double maxRadius = min(size.width, size.height) / 2 - 4;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final int count = rings.length;

    for (int i = 0; i < count; i++) {
      final double radius = maxRadius - (i * 10);
      final ProgressRingData data = rings[i];
      final Paint track = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSizes.borderThick * 2
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, track);

      final Paint fill = Paint()
        ..color = data.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSizes.borderThick * 2
        ..strokeCap = StrokeCap.round;
      final double sweep = (data.value.clamp(0.0, 1.0)) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweep,
        false,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) =>
      oldDelegate.rings != rings || oldDelegate.backgroundColor != backgroundColor;
}