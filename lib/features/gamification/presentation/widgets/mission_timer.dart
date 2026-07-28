import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';

/// Countdown widget ticking down to a fixed point in the future.
///
/// Owns its own [Timer.periodic] so callers don't need to. The timer
/// is cancelled on dispose — verified by the widget test suite.
class MissionTimer extends StatefulWidget {
  const MissionTimer({
    super.key,
    required this.expiresAt,
    this.label,
    this.fontSize = 14.0,
    this.compact = false,
  });

  /// Target instant. When `expiresAt` has already passed the widget
  /// renders the [MissionStrings.timerFallback] glyph and stops
  /// ticking.
  final DateTime expiresAt;

  /// Optional prefix label (e.g. "Resets in"). When omitted the
  /// widget renders only the countdown digits.
  final String? label;

  final double fontSize;
  final bool compact;

  @override
  State<MissionTimer> createState() => _MissionTimerState();
}

class _MissionTimerState extends State<MissionTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tick(),
    );
  }

  @override
  void didUpdateWidget(covariant MissionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiresAt != widget.expiresAt) {
      _remaining = _computeRemaining();
    }
  }

  void _tick() {
    if (!mounted) {
      _timer?.cancel();
      return;
    }
    final Duration next = _computeRemaining();
    if (next == _remaining) return;
    setState(() => _remaining = next);
  }

  Duration _computeRemaining() {
    final Duration diff = widget.expiresAt.difference(DateTime.now());
    if (diff.isNegative) return Duration.zero;
    return diff;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  String _format() {
    if (_remaining == Duration.zero) return MissionStrings.timerFallback;
    final int days = _remaining.inDays;
    final int hours = _remaining.inHours.remainder(24);
    final int minutes = _remaining.inMinutes.remainder(60);
    final int seconds = _remaining.inSeconds.remainder(60);
    if (days > 0) {
      return MissionStrings.daysTemplate
          .replaceFirst('%d', '$days')
          .replaceFirst('%02d', hours.toString().padLeft(2, '0'))
          .replaceFirst('%02d', minutes.toString().padLeft(2, '0'))
          .replaceFirst('%02d', seconds.toString().padLeft(2, '0'));
    }
    return MissionStrings.timeTemplate
        .replaceFirst('%02d', hours.toString().padLeft(2, '0'))
        .replaceFirst('%02d', minutes.toString().padLeft(2, '0'))
        .replaceFirst('%02d', seconds.toString().padLeft(2, '0'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          AppIcons.clock,
          size: widget.compact ? 12 : widget.fontSize + 2,
          color: AppColors.secondary,
        ),
        SizedBox(width: widget.compact ? AppSpacing.xxs : AppSpacing.xs),
        if (widget.label != null) ...<Widget>[
          Text(
            widget.label!,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          _format(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: widget.fontSize,
            color: AppColors.secondary,
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}