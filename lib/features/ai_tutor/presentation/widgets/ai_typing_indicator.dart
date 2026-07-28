import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';

/// A compact "AI is typing" indicator shown while the tutor is
/// drafting its reply. Composed of three pulsing dots inside a
/// glass surface.
class AiTutorTypingIndicator extends StatefulWidget {
  const AiTutorTypingIndicator({super.key});

  @override
  State<AiTutorTypingIndicator> createState() => _AiTutorTypingIndicatorState();
}

class _AiTutorTypingIndicatorState extends State<AiTutorTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < 3; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  final double phase =
                      ((_controller.value + (i * 0.2)) % 1.0).clamp(0.0, 1.0);
                  final double scale = 0.6 + 0.4 * (1 - (phase - 0.5).abs() * 2);
                  return Opacity(
                    opacity: 0.4 + 0.6 * scale,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Tutor is thinking…',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}