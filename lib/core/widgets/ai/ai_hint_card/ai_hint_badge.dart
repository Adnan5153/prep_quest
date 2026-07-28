import 'package:flutter/material.dart';
import 'ai_hint_constants.dart';

class AiHintBadge extends StatelessWidget {
  const AiHintBadge({super.key, required this.type, required this.label});

  final AiHintType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AiHintConstants.colorForType(type);

    return Container(
      height: AiHintConstants.badgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AiHintConstants.pillRadius),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.0),
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: accent,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}
