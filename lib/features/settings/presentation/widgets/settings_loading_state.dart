import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';

/// Indeterminate loading shimmer used while the SettingsController
/// fetches or persists settings.
class SettingsLoadingState extends StatelessWidget {
  const SettingsLoadingState({
    super.key,
    this.title = 'Loading settings…',
    this.subtitle = 'Hang tight while we gather your preferences.',
    this.skeletonRows = 6,
  });

  final String title;
  final String subtitle;
  final int skeletonRows;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: AppSizes.iconXl,
                height: AppSizes.iconXl,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              GlassCard(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < skeletonRows; i++) ...<Widget>[
                      _SkeletonRow(opacity: 1 - (i * 0.12)),
                      if (i != skeletonRows - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatefulWidget {
  const _SkeletonRow({required this.opacity});

  final double opacity;

  @override
  State<_SkeletonRow> createState() => _SkeletonRowState();
}

class _SkeletonRowState extends State<_SkeletonRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color base =
        theme.colorScheme.onSurface.withValues(alpha: 0.08);
    final Color highlight = theme.colorScheme.onSurface
        .withValues(alpha: 0.18);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final double t = _controller.value;
        return Row(
          children: <Widget>[
            Container(
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              decoration: BoxDecoration(
                color: Color.lerp(base, highlight, t),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color.lerp(base, highlight, t),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  FractionallySizedBox(
                    widthFactor: 0.7 * widget.opacity.clamp(0.4, 1),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color.lerp(base, highlight, t),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}