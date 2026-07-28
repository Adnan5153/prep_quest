import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable placeholder shown for features that are under development.
class ComingSoon extends StatelessWidget {
  const ComingSoon({
    super.key,
    this.title = 'Coming Soon',
    this.subtitle = 'This feature is currently under development.',
    this.icon = Icons.rocket_launch_rounded,
    this.buttonText,
    this.onPressed,
    this.showButton = false,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
  });

  final String title;
  final String subtitle;
  final IconData icon;

  final bool showButton;

  final String? buttonText;

  final VoidCallback? onPressed;

  final double maxWidth;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        final avatarRadius = availableHeight < 260 ? 28.0 : 44.0;
        final iconSize = availableHeight < 260 ? 28.0 : 42.0;

        return Center(
          child: SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .12,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: iconSize,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),

                      if (showButton) ...[
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton(
                          onPressed: onPressed,
                          child: Text(buttonText ?? 'Notify Me'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
