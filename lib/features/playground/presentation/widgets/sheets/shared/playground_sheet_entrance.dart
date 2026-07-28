import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';

enum PlaygroundSheetPhase { idle, entering, exited }

class PlaygroundSheetEntrance extends StatefulWidget {
  const PlaygroundSheetEntrance({
    super.key,
    required this.child,
    this.height,
    this.reverse = false,
    this.onExited,
  });

  final Widget child;
  final double? height;
  final bool reverse;
  final VoidCallback? onExited;

  @override
  State<PlaygroundSheetEntrance> createState() =>
      _PlaygroundSheetEntranceState();
}

class _PlaygroundSheetEntranceState extends State<PlaygroundSheetEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.reverse
          ? PlaygroundSheetDurations.exit
          : PlaygroundSheetDurations.entrance,
      vsync: this,
    );
    _slide =
        Tween<double>(
          begin: PlaygroundSheetMotion.slideBegin,
          end: PlaygroundSheetMotion.slideEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.reverse
                ? PlaygroundSheetCurves.exit
                : PlaygroundSheetCurves.enter,
          ),
        );
    _fade =
        Tween<double>(
          begin: widget.reverse
              ? PlaygroundSheetMotion.fadeEnd
              : PlaygroundSheetMotion.fadeBegin,
          end: widget.reverse
              ? PlaygroundSheetMotion.fadeBegin
              : PlaygroundSheetMotion.fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.reverse
                ? PlaygroundSheetCurves.exit
                : PlaygroundSheetCurves.enter,
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant PlaygroundSheetEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reverse != oldWidget.reverse) {
      _controller.duration = widget.reverse
          ? PlaygroundSheetDurations.exit
          : PlaygroundSheetDurations.entrance;
    }
    _syncAnimation();
  }

  void _syncAnimation() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      if (widget.reverse) {
        _controller.value = PlaygroundSheetMotion.fadeBegin;
      } else {
        _controller.value = PlaygroundSheetMotion.fadeEnd;
      }
      if (widget.onExited != null && widget.reverse) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onExited?.call(),
        );
      }
      return;
    }
    if (widget.reverse) {
      if (!_controller.isAnimating &&
          _controller.value == PlaygroundSheetMotion.fadeEnd) {
        _controller.reverse().whenComplete(() {
          if (!mounted) return;
          widget.onExited?.call();
        });
      }
    } else {
      if (!_controller.isAnimating && _controller.value == 0.0) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slideOffset = (widget.height ?? 0) * _slide.value;
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, slideOffset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
