import 'package:flutter/material.dart';

import '../../../../constants/app_icons.dart';
import '../../../../constants/app_sizes.dart';
import '../../ai_constants.dart';

/// Animated heart indicator used inside a history card's trailing area.
class AiHistoryFavoriteIndicator extends StatefulWidget {
  const AiHistoryFavoriteIndicator({
    super.key,
    required this.active,
    required this.color,
  });

  final bool active;
  final Color color;

  @override
  State<AiHistoryFavoriteIndicator> createState() =>
      _AiHistoryFavoriteIndicatorState();
}

class _AiHistoryFavoriteIndicatorState extends State<AiHistoryFavoriteIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AiConstants.fastDuration,
    value: widget.active ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(covariant AiHistoryFavoriteIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      ),
      child: Icon(
        widget.active ? Icons.favorite_rounded : AppIcons.heart,
        size: AppSizes.iconSm,
        color: widget.active
            ? widget.color
            : widget.color.withValues(alpha: 0.55),
      ),
    );
  }
}
