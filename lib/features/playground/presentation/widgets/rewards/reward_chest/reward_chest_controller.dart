import 'package:flutter/material.dart';

import 'reward_chest_models.dart';

class RewardChestController extends StatefulWidget {
  const RewardChestController({
    super.key,
    required this.state,
    required this.autoOpen,
    required this.duration,
    required this.onOpen,
    required this.child,
  });

  final RewardChestState state;
  final bool autoOpen;
  final Duration duration;
  final VoidCallback onOpen;
  final Widget Function(BuildContext context, Animation<double> animation)
  child;

  @override
  State<RewardChestController> createState() => _RewardChestControllerState();
}

class _RewardChestControllerState extends State<RewardChestController>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _openScheduled = false;
  bool _openNotified = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    if (widget.state == RewardChestState.opened) {
      _controller.value = 1.0;
      _openNotified = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.state == RewardChestState.opening || widget.autoOpen) {
      _scheduleOpen();
    }
  }

  void _scheduleOpen() {
    if (_openScheduled || _openNotified) return;
    _openScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openScheduled = false;
      _startOpen();
    });
  }

  void _startOpen() {
    if (_openNotified || _controller.isAnimating) return;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1.0;
      _notifyOpen();
      return;
    }
    if (_controller.value >= 1.0) {
      _notifyOpen();
      return;
    }
    _controller.forward().whenComplete(() {
      if (!mounted || _controller.status != AnimationStatus.completed) return;
      _notifyOpen();
    });
  }

  void _notifyOpen() {
    if (_openNotified) return;
    _openNotified = true;
    widget.onOpen.call();
  }

  @override
  void didUpdateWidget(covariant RewardChestController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    final isOpeningState =
        widget.state == RewardChestState.opening ||
        widget.state == RewardChestState.opened;
    final wasOpeningState =
        oldWidget.state == RewardChestState.opening ||
        oldWidget.state == RewardChestState.opened;

    if ((isOpeningState && !wasOpeningState) ||
        (widget.autoOpen && !oldWidget.autoOpen)) {
      _scheduleOpen();
    } else if (!isOpeningState && wasOpeningState) {
      _openNotified = false;
      _controller.reverse();
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
      builder: (context, _) {
        return widget.child(context, _controller);
      },
    );
  }
}
