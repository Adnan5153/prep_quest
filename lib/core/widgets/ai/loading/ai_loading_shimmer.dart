import 'package:flutter/material.dart';

import '../ai_constants.dart';

/// Stateful host for the AI loading shimmer animation.
///
/// Owns a single [AnimationController] tuned to
/// [AiConstants.streamingDuration] and exposes it via [controller] so any
/// descendant bar can subscribe with one [AnimatedBuilder]. Honours
/// [MediaQuery.disableAnimationsOf] and the [enabled] flag — when either
/// disables motion, the controller is stopped and descendants receive
/// [enabled] = `false`, falling back to flat skeleton bars.
class AiLoadingShimmer extends StatefulWidget {
  const AiLoadingShimmer({super.key, this.enabled = true, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<AiLoadingShimmer> createState() => _AiLoadingShimmerState();
}

class _AiLoadingShimmerState extends State<AiLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AiConstants.streamingDuration,
  );

  bool _animationsAllowed = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyAnimationsAllowed(_resolveAnimationsAllowed());
  }

  @override
  void didUpdateWidget(covariant AiLoadingShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _applyAnimationsAllowed(_resolveAnimationsAllowed());
  }

  bool _resolveAnimationsAllowed() {
    return widget.enabled && !MediaQuery.disableAnimationsOf(context);
  }

  void _applyAnimationsAllowed(bool shouldRun) {
    if (shouldRun == _animationsAllowed) {
      return;
    }
    _animationsAllowed = shouldRun;
    if (shouldRun) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AiLoadingShimmerScope(
      controller: _controller,
      enabled: _animationsAllowed,
      child: widget.child,
    );
  }
}

/// Inherited exposure point for [AiLoadingShimmer] descendants. Children
/// read [controller] / [enabled] via [AiLoadingShimmerScope.of].
class AiLoadingShimmerScope extends InheritedWidget {
  const AiLoadingShimmerScope({
    super.key,
    required this.controller,
    required this.enabled,
    required super.child,
  });

  final AnimationController controller;
  final bool enabled;

  static AiLoadingShimmerScope of(BuildContext context) {
    final AiLoadingShimmerScope? scope = context
        .dependOnInheritedWidgetOfExactType<AiLoadingShimmerScope>();
    assert(
      scope != null,
      'AiLoadingShimmerScope.of() called outside an AiLoadingShimmer host. '
      'Wrap the widget tree in AiLoadingShimmer(child: …) or pass the '
      'controller explicitly.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AiLoadingShimmerScope oldWidget) {
    return oldWidget.controller != controller || oldWidget.enabled != enabled;
  }
}
