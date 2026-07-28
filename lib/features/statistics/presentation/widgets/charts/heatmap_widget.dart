import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/statistics_entity.dart';

class StudyHeatmapWidget extends StatelessWidget {
  const StudyHeatmapWidget({
    super.key,
    required this.cells,
    this.title,
    this.subtitle,
  });

  final List<HeatmapCell> cells;
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
          CustomPaint(
            size: const Size(double.infinity, 140),
            painter: _HeatmapPainter(
              cells: cells,
              emptyColor: theme.dividerColor.withValues(alpha: 0.3),
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const _Legend(),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text('Less', style: theme.textTheme.labelSmall),
        const SizedBox(width: AppSpacing.xs),
        for (final double opacity in const <double>[0.15, 0.35, 0.6, 0.85, 1.0])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ),
        const SizedBox(width: AppSpacing.xs),
        Text('More', style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.cells,
    required this.emptyColor,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final List<HeatmapCell> cells;
  final Color emptyColor;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;
    final int columns = _columnCount();
    final int rows = (cells.length / columns).ceil();
    final double cellSize = size.width / columns;
    final double totalHeight = cellSize * rows;
    final double topOffset = (size.height - totalHeight) / 2;
    final double gap = 2.0;

    for (int i = 0; i < cells.length; i++) {
      final int row = i ~/ columns;
      final int col = i % columns;
      final HeatmapCell cell = cells[i];
      final Rect rect = Rect.fromLTWH(
        col * cellSize + gap / 2,
        topOffset + row * cellSize + gap / 2,
        cellSize - gap,
        cellSize - gap,
      );
      final RRect rrect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(3),
      );
      final Paint paint = Paint();
      if (cell.intensity <= 0) {
        paint.color = emptyColor;
      } else {
        paint.color = Color.lerp(
          secondaryColor.withValues(alpha: 0.15),
          primaryColor,
          cell.intensity,
        )!;
      }
      canvas.drawRRect(rrect, paint);
    }
  }

  int _columnCount() {
    if (cells.isEmpty) return 1;
    final DateTime first = cells.first.date;
    final int weekday = first.weekday % 7;
    return weekday + (cells.length ~/ 7 + (weekday > 0 ? 1 : 0)) * 7;
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) =>
      oldDelegate.cells != cells || oldDelegate.primaryColor != primaryColor;
}