import 'package:flutter/material.dart';

import '../ai_error_state.dart';

class AiErrorStateEntrance extends StatelessWidget {
  const AiErrorStateEntrance({
    super.key,
    required this.animation,
    required this.duration,
    required this.child,
  });

  final AiErrorStateAnimation animation;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? c) {
        final double opacity = value.clamp(0.0, 1.0);
        final double rise = (1.0 - value) * 12.0;
        final double scale = animation == AiErrorStateAnimation.fadeScale
            ? 0.96 + (0.04 * value)
            : 1.0;

        Widget rendered = c ?? const SizedBox.shrink();
        if (animation != AiErrorStateAnimation.fade) {
          rendered = Transform.translate(
            offset: Offset(0, rise),
            child: rendered,
          );
        }
        if (animation == AiErrorStateAnimation.fadeScale) {
          rendered = Transform.scale(scale: scale, child: rendered);
        }

        return Opacity(opacity: opacity, child: rendered);
      },
      child: child,
    );
  }
}
