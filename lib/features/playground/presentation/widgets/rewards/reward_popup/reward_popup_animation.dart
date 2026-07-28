import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';

class RewardPopupEntrance extends StatefulWidget {
  const RewardPopupEntrance({super.key, required this.child});

  final Widget child;

  @override
  State<RewardPopupEntrance> createState() => _RewardPopupEntranceState();
}

class _RewardPopupEntranceState extends State<RewardPopupEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: PlaygroundDurations.rewardPopupEntrance,
      vsync: this,
    );
    _scale =
        Tween<double>(
          begin: RewardPopupEntranceValues.scaleBegin,
          end: RewardPopupEntranceValues.scaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: PlaygroundCurves.cardEntrance,
          ),
        );
    _fade =
        Tween<double>(
          begin: RewardPopupEntranceValues.fadeBegin,
          end: RewardPopupEntranceValues.fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: PlaygroundCurves.rewardPopupEntranceFade,
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant RewardPopupEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      if (_controller.value != RewardPopupEntranceValues.fadeEnd) {
        _controller.value = RewardPopupEntranceValues.fadeEnd;
      }
      return;
    }
    if (!_controller.isAnimating && _controller.value == 0.0) {
      _controller.forward();
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
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
