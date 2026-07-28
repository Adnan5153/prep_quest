import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Lightweight footer for settings screens. Renders an app version
/// line and optional secondary text (e.g. copyright).
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({
    super.key,
    required this.version,
    this.copyright,
    this.alignment = MainAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xl,
    ),
  });

  final String version;
  final String? copyright;
  final MainAxisAlignment alignment;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Prep Quest · v$version',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.lightMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          if (copyright != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              copyright!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.lightMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}