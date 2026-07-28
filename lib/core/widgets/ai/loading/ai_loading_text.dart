import 'package:flutter/material.dart';

import 'ai_loading_constants.dart';
import 'ai_loading_extensions.dart';
import 'ai_loading_shimmer.dart';

/// A single shimmer bar — the foundational skeleton primitive used by
/// every variant of [AiLoadingCard], [AiLoadingSection] and any future
/// caller that needs a placeholder line.
///
/// The bar subscribes to the ambient [AiLoadingShimmerScope] when one
/// is present in the tree. When [controller] is supplied explicitly
/// the bar subscribes to that controller instead. When neither is
/// available (or the ambient shimmer is disabled for reduced-motion)
/// the bar renders as a flat [Container].
class AiLoadingText extends StatelessWidget {
  const AiLoadingText({
    super.key,
    this.width = double.infinity,
    this.height = 10,
    this.radius = 4,
    this.controller,
    this.palette,
  });

  final double width;
  final double height;
  final double radius;
  final AnimationController? controller;
  final LoadingPalette? palette;

  @override
  Widget build(BuildContext context) {
    final LoadingPalette resolved = palette ?? context.loadingPalette;

    AnimationController? activeController = controller;
    bool activeEnabled = true;
    if (activeController == null) {
      final AiLoadingShimmerScope? scope = context
          .dependOnInheritedWidgetOfExactType<AiLoadingShimmerScope>();
      if (scope != null) {
        activeController = scope.controller;
        activeEnabled = scope.enabled;
      }
    }

    if (activeController == null || !activeEnabled) {
      return _flat(width, height, radius, resolved.base);
    }

    return AnimatedBuilder(
      animation: activeController,
      builder: (BuildContext context, Widget? child) {
        final double t = activeController!.value;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * t, 0),
              end: Alignment(0.0 + 2.0 * t, 0),
              colors: <Color>[resolved.base, resolved.highlight, resolved.base],
              stops: const <double>[0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }

  Widget _flat(double w, double h, double r, Color color) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}
