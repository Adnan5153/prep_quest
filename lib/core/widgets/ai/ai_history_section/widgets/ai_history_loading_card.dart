import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_radius.dart';
import '../../../../constants/app_spacing.dart';
import '../../ai_constants.dart';

/// Single skeleton row used by [AiHistoryLoading].
class AiHistoryLoadingCard extends StatefulWidget {
  const AiHistoryLoadingCard({super.key, required this.isDark});

  final bool isDark;

  @override
  State<AiHistoryLoadingCard> createState() => _AiHistoryLoadingCardState();
}

class _AiHistoryLoadingCardState extends State<AiHistoryLoadingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AiConstants.streamingDuration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color base = widget.isDark
        ? Colors.white.withValues(alpha: 0.06)
        : AppColors.lightMuted.withValues(alpha: 0.12);
    final Color highlight = widget.isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.lightMuted.withValues(alpha: 0.05);

    return Semantics(
      label: 'Loading history',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: widget.isDark
              ? AppColors.darkSurface
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppColors.lightMuted.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBar(
              width: AiConstants.compactAvatarSize + 8,
              height: AiConstants.compactAvatarSize + 8,
              base: base,
              highlight: highlight,
              radius: AppRadius.md,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildBar(
                    width: double.infinity,
                    height: 14,
                    base: base,
                    highlight: highlight,
                    radius: AppRadius.xs,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildBar(
                    width: double.infinity,
                    height: 10,
                    base: base,
                    highlight: highlight,
                    radius: AppRadius.xs,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildBar(
                    width: 180,
                    height: 10,
                    base: base,
                    highlight: highlight,
                    radius: AppRadius.xs,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildBar(
                    width: 96,
                    height: 8,
                    base: base,
                    highlight: highlight,
                    radius: AppRadius.xs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({
    required double width,
    required double height,
    required Color base,
    required Color highlight,
    required double radius,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * t, 0),
              end: Alignment(0.0 + 2.0 * t, 0),
              colors: <Color>[base, highlight, base],
              stops: const <double>[0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}
