import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable divider widget for the application.
class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.label,
    this.icon,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.height = AppSpacing.xl,
    this.isVertical = false,
    this.dashed = false,
    this.spacing = AppSpacing.md,
  });

  final String? label;
  final IconData? icon;
  final Color? color;

  final double thickness;
  final double indent;
  final double endIndent;
  final double height;
  final double spacing;

  final bool isVertical;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.colorScheme.outlineVariant;

    if (isVertical) {
      return VerticalDivider(
        width: height,
        thickness: thickness,
        color: dividerColor,
        indent: indent,
        endIndent: endIndent,
      );
    }

    if (label == null && icon == null && !dashed) {
      return Divider(
        height: height,
        thickness: thickness,
        color: dividerColor,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height / 2),
      child: Row(
        children: [
          Expanded(
            child: _DividerLine(
              dashed: dashed,
              color: dividerColor,
              thickness: thickness,
            ),
          ),
          if (label != null || icon != null) ...[
            SizedBox(width: spacing),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: dividerColor),
                  const SizedBox(width: AppSpacing.xs),
                ],
                if (label != null)
                  Text(
                    label!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: dividerColor,
                    ),
                  ),
              ],
            ),
            SizedBox(width: spacing),
          ],
          Expanded(
            child: _DividerLine(
              dashed: dashed,
              color: dividerColor,
              thickness: thickness,
            ),
          ),
        ],
      ),
    );
  }
}

// Paints a divider line.
class _DividerLine extends StatelessWidget {
  const _DividerLine({
    required this.dashed,
    required this.color,
    required this.thickness,
  });

  final bool dashed;
  final Color color;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    if (!dashed) {
      return Divider(thickness: thickness, color: color, height: thickness);
    }

    return SizedBox(
      height: thickness,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / 8).floor();

          return Row(
            children: List.generate(
              dashCount,
              (_) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
