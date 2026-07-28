import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Countdown chip that disables the "resend OTP" action until the
/// configured timer expires. When the timer reaches zero the chip
/// transitions to a clickable tonal button.
class ResendTimer extends StatefulWidget {
  const ResendTimer({
    super.key,
    required this.duration,
    required this.onResend,
    this.label = 'Resend code',
    this.secondsRemainingFormat = 'Resend available in {s}s',
  });

  final Duration duration;
  final VoidCallback onResend;
  final String label;
  final String secondsRemainingFormat;

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration.inSeconds;
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() {
        _remaining = (_remaining - 1).clamp(0, widget.duration.inSeconds);
      });
      if (_remaining == 0) {
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    if (_remaining != 0) return;
    widget.onResend();
    setState(() => _remaining = widget.duration.inSeconds);
    _start();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool canResend = _remaining == 0;
    final Color background = canResend
        ? AppColors.primary.withValues(alpha: 0.12)
        : theme.colorScheme.surfaceContainerHighest;
    final Color foreground = canResend
        ? AppColors.primary
        : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: canResend ? _handleResend : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                canResend ? Icons.refresh_rounded : Icons.schedule_rounded,
                size: 18,
                color: foreground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                canResend
                    ? widget.label
                    : widget.secondsRemainingFormat.replaceAll(
                        '{s}',
                        _remaining.toString(),
                      ),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}