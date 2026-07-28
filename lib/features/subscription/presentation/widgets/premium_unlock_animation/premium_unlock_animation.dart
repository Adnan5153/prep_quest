import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';

/// Animated unlock effect used by the Purchase Success dialog. A
/// rising chevron pulses outward from a golden core while a ring of
/// rays radiates behind it. Self-contained so the dialog body can
/// simply drop it in.
class PremiumUnlockAnimation extends StatefulWidget {
  const PremiumUnlockAnimation({
    super.key,
    this.size = 160,
    this.autoStart = true,
    this.onCompleted,
  });

  final double size;
  final bool autoStart;
  final VoidCallback? onCompleted;

  @override
  State<PremiumUnlockAnimation> createState() => _PremiumUnlockAnimationState();
}

class _PremiumUnlockAnimationState extends State<PremiumUnlockAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rays;
  late final Animation<double> _core;
  late final Animation<double> _rings;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _rays = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _core = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    );
    _rings = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
    if (widget.autoStart) {
      _controller.forward().whenComplete(() {
        if (mounted) widget.onCompleted?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() {
    if (mounted) _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return CustomPaint(
            painter: _UnlockPainter(
              rays: _rays.value,
              core: _core.value,
              rings: _rings.value,
              color: AppColors.accent,
            ),
          );
        },
      ),
    );
  }
}

class _UnlockPainter extends CustomPainter {
  const _UnlockPainter({
    required this.rays,
    required this.core,
    required this.rings,
    required this.color,
  });

  final double rays;
  final double core;
  final double rings;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width, size.height) / 2;

    // ---- Background rays --------------------------------------------------
    final Paint rayPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final int rayCount = 16;
    for (int i = 0; i < rayCount; i++) {
      final double angle = (i / rayCount) * 2 * math.pi;
      final double r = maxRadius * 0.55;
      final double r2 = maxRadius * (0.65 + 0.25 * rays);
      canvas.drawLine(
        center + Offset(math.cos(angle) * r, math.sin(angle) * r),
        center + Offset(math.cos(angle) * r2, math.sin(angle) * r2),
        rayPaint,
      );
    }

    // ---- Expanding rings --------------------------------------------------
    final Paint ringPaint = Paint()
      ..color = color.withValues(alpha: 0.4 - 0.3 * rings)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      center,
      maxRadius * 0.3 + rings * maxRadius * 0.55,
      ringPaint,
    );

    // ---- Core disc --------------------------------------------------------
    final double coreRadius = maxRadius * 0.25 * core;
    final Paint corePaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[Colors.white, color],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));
    canvas.drawCircle(center, coreRadius, corePaint);

    // ---- Crown / star -----------------------------------------------------
    final double iconSize = maxRadius * 0.18 * core.clamp(0.6, 1.0);
    final TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(0xe8b1), // Icons.workspace_premium
        style: TextStyle(
          fontSize: iconSize * 1.6,
          fontFamily: 'MaterialIcons',
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      center - Offset(iconPainter.width / 2, iconPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_UnlockPainter oldDelegate) {
    return oldDelegate.rays != rays ||
        oldDelegate.core != core ||
        oldDelegate.rings != rings;
  }
}

/// Convenience launcher that pops the success dialog and animates the
/// unlock inside it. Used from `PurchaseFlowScreen`.
Future<void> showPremiumUnlockDialog(
  BuildContext context, {
  required String title,
  required String body,
  required VoidCallback onClose,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const PremiumUnlockAnimation(size: AppSizes.iconXl * 2),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                    foregroundColor:
                        Theme.of(dialogContext).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onClose();
                  },
                  child: const Text('Awesome'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
