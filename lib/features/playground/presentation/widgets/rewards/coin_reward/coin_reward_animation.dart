import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';

class CoinFloatAnimation extends StatefulWidget {
  const CoinFloatAnimation({
    super.key,
    required this.enabled,
    required this.animatedChild,
    required this.staticChild,
  });

  final bool enabled;
  final Widget Function(BuildContext context, Animation<double> animation)
  animatedChild;
  final Widget staticChild;

  @override
  State<CoinFloatAnimation> createState() => _CoinFloatAnimationState();
}

class _CoinFloatAnimationState extends State<CoinFloatAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: PlaygroundDurations.coinHoverSpin,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(covariant CoinFloatAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimationState();
  }

  void _syncAnimationState() {
    final reduceMotion =
        MediaQuery.of(context).disableAnimations || !widget.enabled;
    if (reduceMotion) {
      if (_controller.isAnimating) _controller.stop();
      return;
    }
    if (!_controller.isAnimating) {
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
    return AnimatedBuilder(
      animation: _controller,
      child: widget.staticChild,
      builder: (context, staticChild) {
        final lift = (_controller.value - 0.5) * -2.0;
        return Transform.translate(
          offset: Offset(0, lift),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              staticChild ?? const SizedBox.shrink(),
              Positioned.fill(
                child: widget.animatedChild(context, _controller),
              ),
            ],
          ),
        );
      },
    );
  }
}
