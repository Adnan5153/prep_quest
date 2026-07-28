import 'package:flutter/material.dart';
import 'ai_button_variants.dart';
import 'ai_button_constants.dart';

/// A wrapper widget that applies AI-specific animations to a child.
class AiButtonAnimationWrapper extends StatefulWidget {
  const AiButtonAnimationWrapper({
    super.key,
    required this.child,
    required this.animationType,
    this.isActive = true,
  });

  final Widget child;
  final AiButtonAnimationType animationType;
  final bool isActive;

  @override
  State<AiButtonAnimationWrapper> createState() =>
      _AiButtonAnimationWrapperState();
}

class _AiButtonAnimationWrapperState extends State<AiButtonAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AiButtonConstants.breathingDuration,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(AiButtonAnimationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive ||
        widget.animationType != oldWidget.animationType) {
      if (widget.isActive) {
        _startAnimation();
      } else {
        _controller.stop();
      }
    }
  }

  void _startAnimation() {
    if (widget.animationType == AiButtonAnimationType.breathing ||
        widget.animationType == AiButtonAnimationType.pulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive ||
        widget.animationType == AiButtonAnimationType.none) {
      return widget.child;
    }

    switch (widget.animationType) {
      case AiButtonAnimationType.breathing:
      case AiButtonAnimationType.pulse:
        return ScaleTransition(scale: _animation, child: widget.child);
      case AiButtonAnimationType.fade:
        return AnimatedOpacity(
          opacity: widget.isActive ? 1.0 : 0.5,
          duration: AiButtonConstants.normalDuration,
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }
}
